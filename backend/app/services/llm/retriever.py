import re
import logging
from typing import List, Dict, Any, Tuple
from backend.app.services.llm.dataset_loader import DatasetLoader

logger = logging.getLogger("PasuMitraRetriever")

# Stopwords for lightweight query tokenization
STOPWORDS = {
    "a", "an", "the", "and", "or", "but", "if", "then", "else", "when", "where",
    "why", "how", "what", "who", "which", "is", "are", "was", "were", "be",
    "been", "being", "have", "has", "had", "do", "does", "did", "to", "for",
    "of", "in", "on", "at", "by", "with", "about", "against", "into", "through",
    "during", "before", "after", "above", "below", "to", "from", "up", "down",
    "in", "out", "on", "off", "over", "under", "again", "further", "then", "once",
    "here", "there", "all", "any", "both", "each", "few", "more", "most", "other",
    "some", "such", "no", "nor", "not", "only", "own", "same", "so", "than",
    "too", "very", "s", "t", "can", "will", "just", "don", "should", "now"
}

class Retriever:
    INTENT_KEYWORDS = {
        "breed": ["breed", "native", "exotic", "crossbreed", "gir", "sahiwal", "kangayam", "ongole", 
                  "jersey", "friesian", "brown swiss", "malabari", "swadeshi", "indigenous", "cow", 
                  "cattle", "goat", "sheep", "bull", "breeds"],
        "feed": ["feed", "fodder", "diet", "nutrition", "eat", "silage", "ration", "meal", 
                 "water", "mineral", "mixture", "pasture", "grass", "protein", "fiber", "energy"],
        "disease": ["disease", "sick", "ill", "symptom", "cough", "fever", "diarrhea", "bloat", 
                    "pneumonia", "black quarter", "ppr", "brucellosis", "ringworm", "mastitis", 
                    "ketosis", "theileriosis", "anaplasmosis", "septicemia", "parasite", "pink eye", 
                    "babesiosis", "anthrax", "heat stress", "foot and mouth", "lumpy skin", 
                    "milk fever", "treatment", "vet", "sickness"],
        "vaccination": ["vaccin", "immuniz", "schedule", "shot", "injection", "dose", "preventative", 
                        "booster", "vaccine", "vaccines"],
        "climate": ["climate", "weather", "temperature", "temp", "humidity", "rain", "drought", 
                    "flood", "heat index", "arid", "humid", "winter", "summer", "season", "monsoon",
                    "rainfall", "rainy", "precipitation"],
        "economics": ["economic", "cost", "price", "profit", "income", "expense", "budget", "roi", 
                      "finance", "money", "capital", "maintenance", "purchase", "scheme", "subsidy", 
                      "subsidized", "loan", "cooperative", "pmfby", "rgm", "nlm", "rkvy", "insurance"],
        "prediction": ["predict", "model", "accuracy", "feature", "random forest", "training", 
                       "dataset", "split", "rf", "precision", "recall", "f1", "confusion matrix", 
                       "hyperparameter", "metrics", "test", "train"]
    }

    @classmethod
    def detect_intent(cls, question: str) -> str:
        """Classifies the user's question into one of the 8 intents based on keyword scores."""
        q_clean = re.sub(r"[^\w\s]", "", question.lower())
        q_words = set(q_clean.split())

        scores = {intent: 0 for intent in cls.INTENT_KEYWORDS}

        for intent, keywords in cls.INTENT_KEYWORDS.items():
            for kw in keywords:
                if kw in q_clean:
                    scores[intent] += 2
                if kw in q_words:
                    scores[intent] += 3

        # Add specific overrides
        if any(w in q_words for w in ["fmd", "lsd", "tb", "ppr"]):
            scores["disease"] += 10
            scores["vaccination"] += 5
        if any(w in q_clean for w in ["vaccin", "booster", "dose", "immuniz"]):
            scores["vaccination"] += 12
        if any(w in q_clean for w in ["how much", "cost", "profit", "rupee", "rs", "inr", "subsidy"]):
            scores["economics"] += 8
        if any(w in q_clean for w in ["how to feed", "what to feed", "feed quantity", "silage"]):
            scores["feed"] += 8

        # Find intent with maximum score
        max_intent = "general"
        max_score = 0
        for intent, score in scores.items():
            if score > max_score:
                max_score = score
                max_intent = intent

        if max_score < 3:
            return "general"

        return max_intent

    @classmethod
    def search_dataset(cls, question: str, intent: str) -> List[Dict[str, Any]]:
        """Searches the cached dataset matching the intent and returns the Top 5 relevant records."""
        if intent == "general":
            return []

        if intent == "breed":
            try:
                from app.services.llm.breed_retriever import BreedRetrievalService
            except ImportError:
                from backend.app.services.llm.breed_retriever import BreedRetrievalService
            return BreedRetrievalService.retrieve_breeds(question)

        if intent == "feed":
            try:
                from app.services.llm.feed_retriever import FeedRetrievalService
            except ImportError:
                from backend.app.services.llm.feed_retriever import FeedRetrievalService
            return FeedRetrievalService.retrieve_feeds(question)

        records = DatasetLoader.get_records(intent)
        if not records:
            logger.warning(f"No cached records found for intent dataset: {intent}")
            return []

        # Tokenize the user question
        q_clean = re.sub(r"[^\w\s]", "", question.lower())
        q_tokens = [w for w in q_clean.split() if w not in STOPWORDS and len(w) > 1]

        scored_records = []
        for rec in records:
            score = 0
            searchable_text = " ".join([str(val).lower() for val in rec.values()])

            # 1. Base keyword matches
            for token in q_tokens:
                if token in searchable_text:
                    score += 2
                    if re.search(rf"\b{re.escape(token)}\b", searchable_text):
                        score += 3

            # 2. Specific field booster matches
            if intent == "breed":
                breed_name = str(rec.get("Breed_Name", "")).lower()
                for token in q_tokens:
                    if token in breed_name:
                        score += 15
            elif intent == "disease":
                dis_name = str(rec.get("Disease_Name", "")).lower()
                for token in q_tokens:
                    if token in dis_name:
                        score += 15
            elif intent == "feed":
                breed_name = str(rec.get("Breed_Name", "")).lower()
                for token in q_tokens:
                    if token in breed_name:
                        score += 15
            elif intent == "vaccination":
                dis_name = str(rec.get("Disease", "") or rec.get("Target_Disease", "")).lower()
                for token in q_tokens:
                    if token in dis_name:
                        score += 15
            elif intent == "climate":
                state = str(rec.get("State", "")).lower()
                district = str(rec.get("District", "")).lower()
                for token in q_tokens:
                    if token in state or token in district:
                        score += 15
            elif intent == "economics":
                breed_name = str(rec.get("Breed_Name", "")).lower()
                for token in q_tokens:
                    if token in breed_name:
                        score += 15

            if score > 0:
                scored_records.append((score, rec))

        # Sort by score descending
        scored_records.sort(key=lambda x: x[0], reverse=True)

        # Retrieve top 5 unique records
        top_records = []
        seen = []
        for _, rec in scored_records:
            # Create a simple unique key by converting specific identifier fields
            unique_key = (
                rec.get("Breed_ID") or 
                rec.get("Disease_ID") or 
                rec.get("Vaccine_ID") or 
                rec.get("Climate_ID") or 
                rec.get("Economics_ID") or 
                rec.get("Breed_Name") or
                str(rec)
            )
            if unique_key not in seen:
                seen.append(unique_key)
                top_records.append(rec)
            if len(top_records) == 5:
                break

        # Fallback to general default records of the category if no records matched
        if not top_records:
            logger.info(f"No specific keyword matches for intent '{intent}'. Returning default reference records.")
            top_records = records[:5]

        return top_records
