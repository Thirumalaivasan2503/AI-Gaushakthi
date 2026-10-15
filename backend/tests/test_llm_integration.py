import pytest
from unittest.mock import patch, MagicMock
from backend.app.services.llm.dataset_loader import DatasetLoader
from backend.app.services.llm.retriever import Retriever
from backend.app.services.llm.context_builder import ContextBuilder
from backend.app.services.llm.rag_service import RAGService
from backend.app.services.llm import prompt_builder
from backend.app.services.ai_assistant_service import AIAssistantService

def test_dataset_loader_cache():
    # Trigger loader
    DatasetLoader.load_all()
    # Check all 7 datasets are loaded and cached
    for name in ["breed", "feed", "disease", "vaccination", "climate", "economics", "prediction"]:
        records = DatasetLoader.get_records(name)
        assert len(records) > 0
        df = DatasetLoader.get_dataset(name)
        assert not df.empty

def test_intent_classification():
    # Test intent detection accuracy across categories
    assert Retriever.detect_intent("What is the milk yield of Kangayam breed?") == "breed"
    assert Retriever.detect_intent("Recommend a total mixed ration feed schedule for Murrah") == "feed"
    assert Retriever.detect_intent("What are symptoms of Lumpy Skin Disease?") == "disease"
    assert Retriever.detect_intent("What is the vaccination booster interval for PPR?") == "vaccination"
    assert Retriever.detect_intent("What is the annual rainfall in Tamil Nadu?") == "climate"
    assert Retriever.detect_intent("Tell me about Rashtriya Gokul Mission subsidy and loan benefits") == "economics"
    assert Retriever.detect_intent("What is the precision and recall metric of Random Forest classification?") == "prediction"
    assert Retriever.detect_intent("Hello how is the weather today?") in ("general", "climate")

def test_top_5_records_limit():
    DatasetLoader.load_all()
    # For a broad query, check that the retriever restricts results to <= 5 records
    records = Retriever.search_dataset("cattle and goat fever disease", "disease")
    assert len(records) <= 5
    
    records_feed = Retriever.search_dataset("feed nutrition ration silage", "feed")
    assert len(records_feed) <= 5

def test_context_builder_formatting():
    dummy_records = [
        {"Breed_Name": "Kangayam", "Origin": "Tamil Nadu"},
        {"Breed_Name": "Gir", "Origin": "Gujarat"}
    ]
    context = ContextBuilder.build_context(dummy_records, "breed")
    assert "Kangayam" in context
    assert "Gujarat" in context
    assert "Record 1:" in context
    assert "Record 2:" in context

def test_rag_offline_fallback():
    service = RAGService()
    
    # Mock all providers to fail
    for key in service.providers:
        service.providers[key].generate_completion = MagicMock(side_effect=RuntimeError("API Error"))
        
    with patch("os.getenv") as mock_env:
        # Enable key simulation but fail calls
        mock_env.side_effect = lambda k, d=None: "key" if k in ("GEMINI_API_KEY", "OPENAI_API_KEY", "ANTHROPIC_API_KEY") else d
        
        result = service.chat_with_rag("Explain Gir breed", provider_name="Gemini")
        assert result["provider"] == "GauShakthi AI"
        response = result["response"]
        assert "Gir" in response
        assert "Gujarat" in response
        assert "excellent indigenous breed" in response or "premium indigenous breed" in response or "outstanding" in response or "native indigenous breed" in response

def test_rag_transaction_logger():
    # Verify transaction logger runs without error
    service = RAGService()
    service.providers["gemini"].generate_completion = MagicMock(return_value={
        "provider": "Google Gemini (gemini-2.5-flash)",
        "response": "Here is the response.",
        "language": "en",
        "tokens_used": 50,
        "model": "gemini-2.5-flash",
        "latency_ms": 10
    })
    
    with patch("os.getenv", return_value="mock-key"):
        with patch("logging.Logger.info") as mock_logger_info:
            service.chat_with_rag("Explain Kangayam breed", provider_name="Gemini")
            # Verify logger was called to print the transaction log
            assert mock_logger_info.called

def test_breed_retrieval_service():
    try:
        from app.services.llm.breed_retriever import BreedRetrievalService
    except ImportError:
        from backend.app.services.llm.breed_retriever import BreedRetrievalService
        
    # Test for exotic breeds
    exotic_breeds = BreedRetrievalService.retrieve_breeds("Which exotic breed has the highest milk production?")
    assert len(exotic_breeds) > 0
    first_breed = exotic_breeds[0]
    assert "exotic" in first_breed["Breed_Type"].lower() or "foreign" in first_breed["Breed_Type"].lower()
    
    # Test for low maintenance cost
    low_maint_breeds = BreedRetrievalService.retrieve_breeds("Which breed has low maintenance cost?")
    assert len(low_maint_breeds) > 0
    
    # Test for disease resistance
    resistant_breeds = BreedRetrievalService.retrieve_breeds("Suggest breeds with high disease resistance")
    assert len(resistant_breeds) > 0
    breed_names = [b["Breed_Name"] for b in resistant_breeds]
    assert "Gir" in breed_names or "Kangayam" in breed_names or "Sahiwal" in breed_names or "Ongole" in breed_names

def test_feed_retrieval_service():
    try:
        from app.services.llm.feed_retriever import FeedRetrievalService
    except ImportError:
        from backend.app.services.llm.feed_retriever import FeedRetrievalService

    # Test "What should I feed for cows?"
    res_1 = FeedRetrievalService.retrieve_feeds("What should I feed for cows?")
    assert len(res_1) > 0

    # Test "What feed is good for dairy cattle?"
    res_2 = FeedRetrievalService.retrieve_feeds("What feed is good for dairy cattle?")
    assert len(res_2) > 0
    assert "dairy" in str(res_2[0]).lower() or "commercial dairy" in str(res_2[0]).lower() or "milk" in str(res_2[0]).lower()

    # Test "Best food for Ongole"
    res_3 = FeedRetrievalService.retrieve_feeds("Best food for Ongole")
    assert len(res_3) > 0
    breed_key = next((k for k in res_3[0].keys() if k.lower() in ("suitable_breeds", "breed_name")), None)
    assert breed_key is not None
    assert "ongole" in str(res_3[0][breed_key]).lower()

def test_message_classification_routing():
    service = RAGService()
    
    # 1. Greetings classification
    assert service.classify_message("Good morning!") == "greeting"
    assert service.classify_message("Hi GauShakthi") == "greeting"
    
    # 2. Casual / Identity classification
    assert service.classify_message("Who developed you?") == "casual"
    assert service.classify_message("what is your name?") == "casual"
    assert service.classify_message("How are you?") == "casual"
    
    # 3. Farewell / Appreciation classification
    assert service.classify_message("Bye bye!") == "greeting"
    assert service.classify_message("Good night") == "greeting"
    assert service.classify_message("Awesome, thanks!") == "greeting"
    
    # 4. Livestock questions classification
    assert service.classify_message("What feed should I give for my Gir cow?") == "livestock"
    
    # Mock providers to fail to verify local fallback text
    for key in service.providers:
        service.providers[key].generate_completion = MagicMock(side_effect=RuntimeError("API Error"))
        
    with patch("os.getenv", return_value="mock-key"):
        res = service.chat_with_rag("Hi there!")
        assert "help you today" in res["response"]
        
        res_who = service.chat_with_rag("Who are you?")
        assert "help you today" in res_who["response"]

def test_multilingual_language_detection():
    service = RAGService()
    assert service.detect_language("வணக்கம்") == "ta"
    assert service.detect_language("नमस्ते") == "hi"
    assert service.detect_language("Coimbatore-ku entha maadu nalla irukkum?") == "tanglish"
    assert service.detect_language("Which breed is best for Coimbatore?") == "en"

def test_conversation_memory_pronoun_resolution():
    service = RAGService()
    state = {
        "selected_language": "en",
        "previous_breed": "Kangayam",
        "previous_disease": None,
        "previous_feed": None,
        "previous_vaccination": None,
        "previous_climate": None
    }
    mock_res = {
        "provider": "Google Gemini (gemini-2.5-flash)",
        "response": "What should I feed a Kangayam?",
        "language": "en",
        "tokens_used": 10,
        "model": "gemini-2.5-flash",
        "latency_ms": 5
    }
    for key in service.providers:
        service.providers[key].generate_completion = MagicMock(return_value=mock_res)
    
    resolved = service.resolve_pronouns_and_history("What should I feed it?", state)
    assert "Kangayam" in resolved



