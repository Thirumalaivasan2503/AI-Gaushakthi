import os
import re
import logging
import time
from typing import Dict, Any, List, Optional
from datetime import datetime, timezone

from backend.app.services.llm.dataset_loader import DatasetLoader
from backend.app.services.llm.retriever import Retriever
from backend.app.services.llm.context_builder import ContextBuilder
from backend.app.services.llm.gemini_provider import GeminiProvider
from backend.app.services.llm import prompt_builder

logger = logging.getLogger("PasuMitraRAGService")

class RAGService:
    """Orchestrates the entire RAG pipeline from intent detection to context construction and generation using Google Gemini."""

    def __init__(self):
        self.providers = {
            "gemini": GeminiProvider()
        }
        self.active_provider_key = "gemini"
        # Session history cache
        self.history_cache: Dict[str, List[Dict[str, str]]] = {}
        # Session state memory cache (selected language, previously discussed breed, disease, etc.)
        self.session_states: Dict[str, Dict[str, Any]] = {}

    def mask_pii_data(self, text: str) -> str:
        """Masks sensitive PII numbers (e.g. mobile numbers, Aadhar) before sending to LLM."""
        masked = re.sub(r"\+?\d{10,12}", "[PHONE_MASKED]", text)
        return masked

    def detect_language(self, text: str) -> str:
        """Detects if the query is in English, Tamil, Hindi, or Tanglish."""
        # Quick character check for native scripts
        if any('\u0b80' <= c <= '\u0bff' for c in text):
            return "ta"
        if any('\u0900' <= c <= '\u097f' for c in text):
            return "hi"
            
        # Check common Tanglish vocabulary tokens
        tanglish_words = {"irukkum", "nalla", "enna", "irukku", "panna", "maadu", "sapaadu", "sapadu", "romba", "nanri", "thambi", "bro", "unga", "enaku"}
        clean_words = re.sub(r"[^\w\s]", "", text.lower()).split()
        if any(w in tanglish_words for w in clean_words):
            return "tanglish"
            
        return "en"

    def _local_translate_term(self, text: str) -> str:
        """Translates basic livestock terms to English offline if API translation fails."""
        lower_text = text.lower()
        
        # Breed names mapping
        breeds_map = {
            "காங்கேயம்": "Kangayam",
            "kangayam": "Kangayam",
            "கிர்": "Gir",
            "gir": "Gir",
            "சாஹிவால்": "Sahiwal",
            "sahiwal": "Sahiwal",
            "ஒங்கோல்": "Ongole",
            "ongole": "Ongole",
            "மலபாரி": "Malabari",
            "malabari": "Malabari",
            "ஜெர்சி": "Jersey",
            "jersey": "Jersey",
            "சிந்து": "Sindhi",
            "sindhi": "Sindhi"
        }
        
        # Intent keywords mapping
        intents_map = {
            "தீவனம்": "feed",
            "theevanam": "feed",
            "चारा": "feed",
            "நோய்": "disease",
            "noy": "disease",
            "रोग": "disease",
            "बीमारी": "disease",
            "தடுப்பூசி": "vaccination",
            "टीका": "vaccination"
        }

        # Scan and build a simple English search query
        matched_breeds = [eng for native, eng in breeds_map.items() if native in lower_text]
        matched_intents = [eng for native, eng in intents_map.items() if native in lower_text]

        if matched_breeds or matched_intents:
            parts = []
            if matched_intents:
                parts.append(matched_intents[0])
            if matched_breeds:
                parts.append(f"for {matched_breeds[0]}")
            return " ".join(parts) if parts else text

        return text

    def translate_to_english(self, text: str, source_lang: str) -> str:
        """Translates user text from Tamil, Hindi, or Tanglish into clear plain English."""
        if source_lang == "en":
            return text
        
        prompt = (
            f"You are a translation assistant. Translate the following text into clear, plain English. "
            f"If the text is in Tanglish (Tamil in English script), translate it into English. "
            f"Output ONLY the translated text, no warnings or extra words.\n\nText: {text}"
        )
        try:
            res = self.providers["gemini"].generate_completion(
                user_prompt=prompt,
                system_prompt="Translate directly to English. Output translation only.",
                conversation_history=[]
            )
            translated = res["response"].strip()
            if translated:
                return translated
        except Exception as e:
            logger.error(f"Translation to English failed: {e}")
            
        # Offline translation fallback
        return self._local_translate_term(text)

    def translate_from_english(self, text: str, target_lang: str) -> str:
        """Translates the English response back into the user's preferred target language."""
        if target_lang in ("en", "english"):
            return text
            
        lang_name = "Tamil" if target_lang == "ta" else "Hindi" if target_lang == "hi" else "Tanglish (Tamil written in English script)" if target_lang == "tanglish" else target_lang
        
        prompt = (
            f"You are a translator. Translate the following English response into friendly, natural {lang_name}. "
            f"Output ONLY the translated response. Do not add metadata or extra words.\n\nResponse:\n{text}"
        )
        try:
            res = self.providers["gemini"].generate_completion(
                user_prompt=prompt,
                system_prompt=f"Translate directly to {lang_name}. Output translation only.",
                conversation_history=[]
            )
            translated = res["response"].strip()
            if translated:
                return translated
        except Exception as e:
            logger.error(f"Translation from English to {target_lang} failed: {e}")
        return text

    def resolve_pronouns_and_history(self, query: str, state: Dict[str, Any]) -> str:
        """Resolves pronouns (like 'it') using previously discussed state memory context."""
        clean_words = set(re.sub(r"[^\w\s]", "", query.lower()).split())
        pronouns = {"it", "this", "that", "him", "her", "them", "its"}
        has_pronoun = not clean_words.isdisjoint(pronouns)
        if not has_pronoun:
            return query
            
        context_parts = []
        if state.get("previous_breed"):
            context_parts.append(f"Previously discussed breed: {state['previous_breed']}")
        if state.get("previous_disease"):
            context_parts.append(f"Previously discussed disease: {state['previous_disease']}")
        if state.get("previous_feed"):
            context_parts.append(f"Previously discussed feed: {state['previous_feed']}")
            
        if not context_parts:
            return query
            
        context_str = ", ".join(context_parts)
        prompt = (
            f"You are a linguistic helper. Rewrite the user's follow-up question to replace pronouns like 'it' with their specific reference, using the provided context.\n"
            f"Context: {context_str}\n"
            f"Follow-up: {query}\n"
            f"Output ONLY the resolved question, keeping it simple. Output nothing else."
        )
        try:
            res = self.providers["gemini"].generate_completion(
                user_prompt=prompt,
                system_prompt="Resolve pronouns. Output rewritten query only.",
                conversation_history=[]
            )
            resolved = res["response"].strip()
            if resolved:
                logger.info(f"Resolved pronoun query: '{query}' -> '{resolved}'")
                return resolved
        except Exception as e:
            logger.error(f"Query resolution failed: {e}")
        return query

    def classify_message(self, text: str) -> str:
        """
        Classifies the user message into greeting, casual, general_knowledge, livestock, or unknown.
        Bypasses CSV dataset retrieval for conversational prompts.
        """
        clean_text = re.sub(r"[^\w\s]", "", text.lower()).strip()
        words = clean_text.split()
        
        # Greetings keywords
        greetings = {"hi", "hello", "hloo", "hey", "good morning", "good evening", "good afternoon", "greetings", "vanakkam", "namaste"}
        # Appreciation keywords
        appreciations = {"thanks", "thank you", "thank", "awesome", "great", "cool", "wonderful", "perfect"}
        # Farewell keywords
        farewells = {"bye", "see you", "good night", "goodnight", "farewell", "quit", "exit"}
        
        # Standard livestock terms (expanded for Tamil, Hindi, and Tanglish)
        livestock_keywords = {
            # English
            "breed", "breeds", "indigenous", "exotic", "crossbreed", "foreign", "gir", "sahiwal", "kangayam", "ongole", 
            "jersey", "friesian", "malabari", "cow", "cattle", "goat", "sheep", "bull", "calf", "livestock",
            "feed", "fodder", "diet", "nutrition", "eat", "silage", "ration", "meal", "grass", "food",
            "disease", "sick", "ill", "symptom", "fever", "diarrhea", "bloat", "mastitis", "pox", "rabies", "ppr", "brucellosis", "lumpy",
            "vaccin", "booster", "dose", "immuniz", "schedule", "shot", "injection",
            "climate", "weather", "temperature", "temp", "humidity", "rain", "drought", "rainfall", "monsoon",
            "economic", "cost", "price", "profit", "income", "expense", "budget", "subsidy", "subsidized", "loan", "cooperative",
            "predict", "rf", "random forest", "model", "accuracy", "training", "precision", "recall", "f1",
            "farm", "farming", "advice", "guidance", "agriculture", "farmer", "heat", "stress",
            # Tamil & Tanglish
            "மாடு", "பசு", "இனங்கள்", "இனம்", "காங்கேயம்", "கிர்", "சாஹிவால்", "தீவனம்", "புல்", "உணவு", "சாப்பாடு", "நோய்", 
            "கோமாரி", "சளி", "காய்ச்சல்", "வயிற்றுப்போக்கு", "தடுப்பூசி", "ஊசி", "வானிலை", "மழை", "வெயில்", "பண்ணை",
            "maadu", "pasu", "inam", "theevanam", "theevanam", "pul", "unavu", "sapadu", "noy", "noai", "kaichal", "thaduppoosi",
            # Hindi
            "गाय", "नस्ल", "बैल", "चारा", "खिलाएं", "भोजन", "राशन", "बीमारी", "रोग", "बुखार", "टीका", "टीकाकरण", "मौसम", "बारिश"
        }
        
        if any(w in livestock_keywords for w in words):
            return "livestock"
            
        if clean_text in greetings or any(w in greetings for w in words[:2]):
            return "greeting"
            
        # Identity Question
        identity_keywords = {"who are you", "who developed you", "who created you", "your name", "what is your name", "who made you", "what are you"}
        if any(phrase in clean_text for phrase in identity_keywords) or "who are you" in clean_text:
            return "casual"
            
        if clean_text in appreciations or any(w in appreciations for w in words):
            return "greeting"
        if clean_text in farewells or any(w in farewells for w in words):
            return "greeting"
            
        casual_phrases = [
            "how are you", "what can you do", "tell me about yourself",
            "how is the weather", "whats up", "what's up", "can you help"
        ]
        if any(phrase in clean_text for phrase in casual_phrases):
            return "casual"
            
        return "general_knowledge"

    def _generate_local_fallback(self, clean_prompt: str, records: List[Dict[str, Any]], intent: str, language: str) -> str:
        """
        Offline fallback generator that synthesizes database records into a natural, conversational response.
        Generates responses in selected target language (English, Tamil, Hindi, Tanglish).
        """
        if not records:
            if language == "ta":
                return "மன்னிக்கவும், இந்த கேள்விக்கு நேரடித் தகவல்கள் எதுவும் கிடைக்கவில்லை."
            elif language == "hi":
                return "क्षमा करें, इस विषय पर कोई प्रत्यक्ष डेटा उपलब्ध नहीं है।"
            else:
                return "I do not have verified details on this specific topic right now."

        paragraphs = []

        if intent == "breed":
            for r in records[:2]:
                name = r.get("Breed_Name", "Unknown Breed")
                b_type = r.get("Breed_Type", "indigenous")
                origin = r.get("Origin_State", "India")
                yield_day = r.get("Milk_Yield_Liters_Day", "N/A")
                res = r.get("Disease_Resistance", "High")
                adapt = r.get("Climate_Adaptability", "Good")
                desc = r.get("Description", "")
                
                if language == "ta":
                    paragraphs.append(
                        f"**{name}** என்பது {origin} பகுதியைச் சேர்ந்த ஒரு சிறந்த நாட்டுப்புற {b_type} மாட்டு இனமாகும். "
                        f"இது தினசரி சுமார் {yield_day} லிட்டர் பால் கொடுக்கிறது மற்றும் சிறந்த காலநிலை சகிப்புத்தன்மை மற்றும் "
                        f"அதிக நோய் எதிர்ப்பு சக்தி கொண்டது. {desc}"
                    )
                elif language == "hi":
                    paragraphs.append(
                        f"**{name}** {origin} की एक उत्कृष्ट {b_type} नस्ल है। "
                        f"यह प्रतिदिन लगभग {yield_day} लीटर दूध देती है, और यह अपनी {adapt} जलवायु अनुकूलन क्षमता "
                        f"और {res} रोग प्रतिरोधक क्षमता के लिए प्रसिद्ध है। {desc}"
                    )
                elif language == "tanglish":
                    paragraphs.append(
                        f"**{name}** indigenous {b_type} breed, idhu {origin} state-ai serndhadhu. "
                        f"Idhu daily {yield_day} liters milk tharum, adaptability {adapt}-a irukkum matrum "
                        f"disease resistance {res}-a irukkum. {desc}"
                    )
                else:
                    paragraphs.append(
                        f"**{name}** is an excellent {b_type.lower()} breed originating from {origin}. "
                        f"It produces about {yield_day} liters of milk daily and is highly regarded for its "
                        f"{adapt.lower()} climate adaptability and {res.lower()} disease resistance. {desc}"
                    )

        elif intent == "disease":
            for r in records[:2]:
                name = r.get("Disease_Name", "Unknown Disease")
                species = r.get("Affected_Species", "livestock")
                symptoms = r.get("Symptoms", "")
                cause = r.get("Cause", "")
                severity = r.get("Severity", "medium")
                prev = r.get("Prevention", "")
                treatment = r.get("Treatment", "")
                cost = r.get("Estimated_Treatment_Cost_INR", "0.0")
                action = r.get("Recommended_Action", "")
                
                symptom_text = symptoms.replace(";", ", ").lower()
                
                if language == "ta":
                    paragraphs.append(
                        f"**{name}** என்பது {species}-ஐ பாதிக்கும் ஒரு {severity} நோயாகும். இது பொதுவாக {cause} மூலம் பரவுகிறது. "
                        f"இதன் முக்கிய அறிகுறிகள்: {symptom_text}. {prev} மூலம் இதைத் தடுக்கலாம். "
                        f"இதற்கான சிகிச்சை {treatment} ஆகும், இதற்கு சுமார் ரூ. {cost} செலவாகும். அடுத்த கட்டமாக {action} செய்ய வேண்டும்."
                    )
                elif language == "hi":
                    paragraphs.append(
                        f"**{name}** {species} को प्रभावित करने वाली एक {severity} बीमारी है, जो आमतौर पर {cause} से होती है। "
                        f"इसके लक्षण: {symptom_text}। {prev} द्वारा रोकथाम संभव है। "
                        f"इसका उपचार {treatment} है, जिसमें लगभग रु. {cost} खर्च होता है। तुरंत {action} करें।"
                    )
                elif language == "tanglish":
                    paragraphs.append(
                        f"**{name}** oru {severity} condition affecting {species}. Cause: {cause}. "
                        f"Symptoms: {symptom_text}. prevention: {prev}. "
                        f"Treatment: {treatment}, expected cost Rs. {cost}. Action: {action}."
                    )
                else:
                    paragraphs.append(
                        f"**{name}** is a {severity.lower()} condition affecting {species.lower()}, typically caused by {cause.lower()} issues. "
                        f"Watch out for symptoms like {symptom_text}. You can prevent this by keeping up with {prev.lower()}. "
                        f"Treatment involves {treatment.lower()}, costing around Rs. {cost}. Recommended action: {action.lower()}."
                    )

        elif intent == "feed":
            for r in records[:2]:
                feed_name = r.get("Feed_Name", "fodder")
                category = r.get("Feed_Category", "diet")
                species = r.get("Suitable_Species", "cattle")
                breeds = r.get("Suitable_Breeds", "all breeds")
                purpose = r.get("Purpose", "general health")
                protein = r.get("Protein_Percentage", "")
                fiber = r.get("Fiber_Percentage", "")
                time_of_day = r.get("Feeding_Time", "morning & evening")
                qty = r.get("Recommended_Quantity_Kg_Day", "")
                cost = r.get("Cost_Per_Kg_INR", "")
                remarks = r.get("Remarks", "")
                
                if language == "ta":
                    paragraphs.append(
                        f"**{feed_name}** ({category} வகை) என்பது {breeds} போன்ற {species}-க்கு {purpose} நோக்கத்திற்காக சிறந்த தீவனமாகும். "
                        f"இதை {time_of_day} வேளையில் {qty} கிலோ கிராம் வீதம் வழங்கலாம். இதில் {protein}% புரதம் மற்றும் {fiber}% நார்ச்சத்து உள்ளது. "
                        f"இதன் விலை கிலோவுக்கு ரூ. {cost} ஆகும். குறிப்பு: {remarks}"
                    )
                elif language == "hi":
                    paragraphs.append(
                        f"**{feed_name}** ({category} श्रेणी) {breeds} जैसे {species} के लिए {purpose} उद्देश्य के लिए एक उत्कृष्ट चारा है। "
                        f"इसे {time_of_day} में {qty} किलोग्राम दैनिक मात्रा में दें। इसमें {protein}% प्रोटीन और {fiber}% फाइबर शामिल है। "
                        f"लागत: रु. {cost}/किग्रा। टिप्पणी: {remarks}"
                    )
                elif language == "tanglish":
                    paragraphs.append(
                        f"**{feed_name}** ({category} category) is suitable for {breeds} {species} for {purpose} purpose. "
                        f"Give {qty} kg during {time_of_day}. It has {protein}% protein, {fiber}% fiber. Cost is Rs. {cost}/kg. Note: {remarks}"
                    )
                else:
                    paragraphs.append(
                        f"**{feed_name}** ({category} category) is suitable for {breeds} {species} for {purpose} purpose. "
                        f"Feed {qty} kg daily during the {time_of_day.lower()}. It contains {protein}% protein and {fiber}% fiber, costing Rs. {cost}/kg. Note: {remarks}"
                    )

        elif intent == "vaccination":
            for r in records[:2]:
                vaccine = r.get("Vaccine_Name", "vaccine")
                disease = r.get("Target_Disease", "infection")
                species = r.get("Suitable_Species", "cattle")
                dose = r.get("Dose_Quantity", "")
                age = r.get("First_Dose_Age", "")
                interval = r.get("Booster_Interval_Months", "")
                route = r.get("Administration_Route", "")
                season = r.get("Recommended_Season", "")
                subsidized = r.get("Government_Subsidized", "No")
                remarks = r.get("Veterinary_Remarks", "")
                
                gov_text = "அரசு மானியம் உண்டு." if str(subsidized).lower() in ("yes", "true") else "வணிக ரீதியான தடுப்பூசி."
                gov_text_hi = "यह सरकारी सब्सिडी वाला टीका है।" if str(subsidized).lower() in ("yes", "true") else "व्यावसायिक टीका।"
                gov_text_tanglish = "Govt subsidy irukku." if str(subsidized).lower() in ("yes", "true") else "Commercial vaccine."
                gov_text_en = "This vaccine is government subsidized." if str(subsidized).lower() in ("yes", "true") else "Commercial vaccine."
                
                if language == "ta":
                    paragraphs.append(
                        f"**{disease}** நோய்க்கு எதிராக **{vaccine}** தடுப்பூசியைப் பயன்படுத்தவும். "
                        f"{route} வழியாக {dose} அளவை செலுத்தவும். முதல் தடுப்பூசியை {age}-ல் செலுத்தவும், பூஸ்டர் {interval} ஆகும். "
                        f"{season} காலத்தில் செலுத்துவது நல்லது. {gov_text} {remarks}"
                    )
                elif language == "hi":
                    paragraphs.append(
                        f"**{disease}** बीमारी के लिए **{vaccine}** का उपयोग करें। "
                        f"{route} से {dose} खुराक दें। पहली खुराक की उम्र {age} है और बूस्टर अंतराल {interval} है। "
                        f"{season} के मौसम में लगाना सबसे अच्छा है। {gov_text_hi} {remarks}"
                    )
                elif language == "tanglish":
                    paragraphs.append(
                        f"**{disease}** prevention-ku **{vaccine}** vaccine podunga. Dose: {dose}, route: {route}. "
                        f"First dose at {age}, booster interval: {interval}. Best season: {season}. {gov_text_tanglish} {remarks}"
                    )
                else:
                    paragraphs.append(
                        f"Against **{disease}**, administer **{vaccine}** ({dose}) via {route.lower()} starting at {age}. "
                        f"Booster interval is {interval}. {gov_text_en} {remarks}"
                    )

        elif intent == "climate":
            for r in records[:2]:
                state = r.get("State", "")
                district = r.get("District", "")
                c_type = r.get("Climate_Type", "")
                temp = r.get("Avg_Temperature_C", "")
                humidity = r.get("Avg_Humidity_Percent", "")
                rain = r.get("Annual_Rainfall_mm", "")
                breeds = r.get("Suitable_Breeds", "")
                drought = r.get("Drought_Risk", "Low")
                flood = r.get("Flood_Risk", "Low")
                
                if language == "ta":
                    paragraphs.append(
                        f"**{district}, {state}** காலநிலை {c_type} ஆகும். சராசரி வெப்பநிலை {temp}°C மற்றும் ஈரப்பதம் {humidity}% ஆகும். "
                        f"ஆண்டு மழைப்பொழிவு {rain} மிமீ. வறட்சி அபாயம்: {drought}, வெள்ள அபாயம்: {flood}. "
                        f"இங்கு வளர்க்க தகுந்த மாட்டு இனங்கள்: {breeds}."
                    )
                elif language == "hi":
                    paragraphs.append(
                        f"**{district}, {state}** की जलवायु {c_type} है। औसत तापमान {temp}°C और आर्द्रता {humidity}% है। "
                        f"वार्षिक वर्षा {rain} मिमी है। सूखा खतरा: {drought}, बाढ़ खतरा: {flood}। "
                        f"अनुकूल नस्लें: {breeds}।"
                    )
                elif language == "tanglish":
                    paragraphs.append(
                        f"In **{district}, {state}**, climate type is {c_type}. Avg temp {temp}°C and humidity {humidity}%. "
                        f"Rainfall: {rain} mm. Drought risk: {drought}, flood risk: {flood}. Suitable breeds: {breeds}."
                    )
                else:
                    paragraphs.append(
                        f"In **{district}, {state}**, average temperature is {temp}°C with {humidity}% humidity. "
                        f"Drought risk is {drought.lower()} and suitable breeds are {breeds}."
                    )

        elif intent == "economics":
            for r in records[:2]:
                breed = r.get("Breed_Name", "livestock")
                cost = r.get("Purchase_Cost_INR", "")
                feed_cost = r.get("Daily_Feed_Cost_INR", "")
                maint = r.get("Monthly_Maintenance_Cost_INR", "")
                income = r.get("Annual_Income_INR", "")
                profit = r.get("Net_Profit_INR", "")
                roi = r.get("ROI_Percentage", "")
                break_even = r.get("Break_Even_Months", "")
                purpose = r.get("Purpose", "")
                rec_farmer = r.get("Recommended_For", "")
                
                if language == "ta":
                    paragraphs.append(
                        f"**{breed}** பண்ணை அமைக்க ஆரம்ப கொள்முதல் விலை ரூ. {cost} ஆகும். "
                        f"மாத பராமரிப்பு செலவு ரூ. {maint} மற்றும் தீவன செலவு ஒரு நாளைக்கு ரூ. {feed_cost} ஆகும். "
                        f"இது ஆண்டுக்கு ரூ. {income} வருமானம் தரும், நிகர லாபம் ரூ. {profit} ஆகும். "
                        f"இதன் ROI {roi}% மற்றும் முதலீட்டை திரும்பப் பெறும் காலம் {break_even} மாதங்கள் ஆகும்."
                    )
                elif language == "hi":
                    paragraphs.append(
                        f"**{breed}** डेयरी फार्म शुरू करने के लिए खरीद लागत रु. {cost} है। "
                        f"मासिक रखरखाव रु. {maint} और दैनिक चारा लागत रु. {feed_cost} है। "
                        f"यह वार्षिक आय रु. {income} दे सकती है, शुद्ध लाभ रु. {profit} होगा। "
                        f"ROI {roi}% और ब्रेक-ईवन अवधि {break_even} महीने है।"
                    )
                elif language == "tanglish":
                    paragraphs.append(
                        f"**{breed}** farm purchase cost per animal Rs. {cost}, daily feed cost Rs. {feed_cost}. "
                        f"Expected income Rs. {income}, profit Rs. {profit}. ROI: {roi}% and break-even: {break_even} months."
                    )
                else:
                    paragraphs.append(
                        f"Setting up a **{breed}** farm requires purchase cost of Rs. {cost} per animal. "
                        f"Expected annual net profit is Rs. {profit} with a break-even period of {break_even} months."
                    )

        elif intent == "prediction":
            for r in records[:1]:
                state = r.get("State", "")
                district = r.get("District", "")
                feed_budget = r.get("Feed_Budget_INR", "")
                
                if language == "ta":
                    paragraphs.append(f"**{district}, {state}** பகுதியில் உள்ள விவசாயிகள் சராசரியாக மாதம் ரூ. {feed_budget} தீவன பட்ஜெட் நிர்வகிக்கிறார்கள்.")
                elif language == "hi":
                    paragraphs.append(f"**{district}, {state}** के किसान औसतन रु. {feed_budget}/माह का चारा बजट प्रबंधित करते हैं।")
                else:
                    paragraphs.append(f"Farmers in **{district}, {state}** manage a feed budget of Rs. {feed_budget}/month.")
        else:
            if language == "ta":
                paragraphs.append("தகவல் எதுவும் கிடைக்கவில்லை.")
            elif language == "hi":
                paragraphs.append("कोई जानकारी नहीं मिली।")
            else:
                paragraphs.append("No details found.")

        details = "\n\n".join(paragraphs)
        return details

    def _log_transaction(self, user_prompt: str, pref_lang: str, english_prompt: str, resolved_prompt: str, msg_category: str, intent: str, dataset_used: str, records: list, successful_res: dict, start_time: float, response_source: str, context_len: int = 0):
        """Standardizes transaction logging across all routing responses with required debugging fields."""
        response_time = f"{(time.time() - start_time):.3f}s"
        logger.info(
            f"\n=== RAG TRANSACTION LOG ===\n"
            f"User Question         : {user_prompt}\n"
            f"Detected Lang         : {pref_lang}\n"
            f"English Trans         : {english_prompt}\n"
            f"Resolved Prompt       : {resolved_prompt}\n"
            f"Message Category      : {msg_category}\n"
            f"Detected Intent       : {intent}\n"
            f"Dataset Searched      : {dataset_used}\n"
            f"Records Found         : {len(records)}\n"
            f"Context Length (chars): {context_len}\n"
            f"LLM Provider Used     : {successful_res.get('provider', 'GauShakthi AI')}\n"
            f"Response Time         : {response_time}\n"
            f"Latency (ms)          : {successful_res.get('latency_ms', 0)}ms\n"
            f"Final Response Source : {response_source}\n"
            f"===========================\n"
        )

    def chat_with_rag(
        self,
        user_prompt: str,
        language: str = None,
        context_history: List[dict] = None,
        provider_name: str = None,
        conversation_id: str = None
    ) -> Dict[str, Any]:
        start_time = time.time()

        # 1. Mask PII
        clean_prompt = self.mask_pii_data(user_prompt)

        # 2. Initialize or load Conversation Memory State
        if conversation_id:
            if conversation_id not in self.session_states:
                self.session_states[conversation_id] = {
                    "selected_language": language or "en",
                    "previous_breed": None,
                    "previous_disease": None,
                    "previous_feed": None,
                    "previous_vaccination": None,
                    "previous_climate": None
                }
            state = self.session_states[conversation_id]
        else:
            state = {
                "selected_language": language or "en",
                "previous_breed": None,
                "previous_disease": None,
                "previous_feed": None,
                "previous_vaccination": None,
                "previous_climate": None
            }

        # 3. Resolve preferred language
        lang_normalize = {
            "english": "en",
            "tamil": "ta",
            "hindi": "hi",
            "tanglish": "tanglish",
            "en": "en",
            "ta": "ta",
            "hi": "hi"
        }
        if language:
            pref_lang = lang_normalize.get(language.lower(), "en")
        else:
            pref_lang = self.detect_language(clean_prompt)
            
        state["selected_language"] = pref_lang

        # 4. Translate incoming query to English internally for RAG pipeline search
        english_prompt = self.translate_to_english(clean_prompt, pref_lang)

        # 5. Resolve pronouns (like 'it') using conversation history state
        resolved_english_prompt = self.resolve_pronouns_and_history(english_prompt, state)

        # 6. Classify Message
        msg_category = self.classify_message(resolved_english_prompt)

        # 7. Local Offline Greetings Fallback definition
        local_greetings = {
            "en": "Hello! 👋\nHow can I help you today?",
            "ta": "வணக்கம்! 😊\nஉங்களுக்கு என்ன உதவி வேண்டும்?",
            "hi": "नमस्ते! 😊\nमैं आपकी किस प्रकार सहायता कर सकता हूँ?",
            "tanglish": "Vanakkam 😊\nEnna help pannalam?"
        }

        # 8. Check if Greeting: Bypass dataset RAG and call Gemini directly
        if msg_category == "greeting":
            intent = "general"
            records = []
            dataset_used = "None (Conversational)"
            system_prompt = prompt_builder.build_system_prompt(language=pref_lang)
            formatted_user_prompt = f"User Message: {resolved_english_prompt}"
            
            gemini_failed = False
            if not os.getenv("GEMINI_API_KEY"):
                gemini_failed = True
            else:
                try:
                    res = self.providers["gemini"].generate_completion(
                        user_prompt=formatted_user_prompt,
                        system_prompt=system_prompt,
                        conversation_history=context_history or self.history_cache.get(conversation_id, []),
                        language=pref_lang
                    )
                    latency_ms = int((time.time() - start_time) * 1000)
                    res["latency_ms"] = latency_ms
                    successful_res = res
                except Exception as e:
                    logger.error(f"Gemini greeting call failed: {e}")
                    gemini_failed = True
                    
            if gemini_failed:
                fallback_text = local_greetings.get(pref_lang, local_greetings["en"])
                successful_res = {
                    "provider": "GauShakthi AI",
                    "response": fallback_text,
                    "language": pref_lang,
                    "tokens_used": len(clean_prompt.split()) + len(fallback_text.split()),
                    "model": "local-fallback-v1",
                    "latency_ms": int((time.time() - start_time) * 1000),
                    "citations": [],
                }
            
            # Update history cache
            if conversation_id:
                if conversation_id not in self.history_cache:
                    self.history_cache[conversation_id] = []
                self.history_cache[conversation_id].append({"role": "user", "content": clean_prompt})
                self.history_cache[conversation_id].append({"role": "assistant", "content": successful_res["response"]})
            
            self._log_transaction(clean_prompt, pref_lang, english_prompt, resolved_english_prompt, msg_category, intent, dataset_used, records, successful_res, start_time, response_source="Gemini only" if not gemini_failed else "Offline Fallback")
            return successful_res

        # 9. Check if Livestock Question: Search dataset first
        elif msg_category == "livestock":
            intent = Retriever.detect_intent(resolved_english_prompt)
            dataset_used = DatasetLoader.DATASET_FILES.get(intent, "None (General)")
            records = Retriever.search_dataset(resolved_english_prompt, intent)

            # If records are found: Build context, send prompt + context to Gemini
            if records:
                context = ContextBuilder.build_context(records, intent)
                system_prompt = prompt_builder.build_system_prompt(language=pref_lang)
                formatted_user_prompt = prompt_builder.build_user_message(
                    user_question=resolved_english_prompt,
                    context=context,
                    language=pref_lang
                )

                gemini_failed = False
                if not os.getenv("GEMINI_API_KEY"):
                    gemini_failed = True
                else:
                    try:
                        res = self.providers["gemini"].generate_completion(
                            user_prompt=formatted_user_prompt,
                            system_prompt=system_prompt,
                            conversation_history=context_history or self.history_cache.get(conversation_id, []),
                            language=pref_lang
                        )
                        latency_ms = int((time.time() - start_time) * 1000)
                        res["latency_ms"] = latency_ms
                        successful_res = res
                    except Exception as e:
                        logger.error(f"Gemini RAG call failed: {e}")
                        gemini_failed = True

                # If Gemini fails, fallback to direct local dataset synthesis
                if gemini_failed:
                    fallback_text = self._generate_local_fallback(resolved_english_prompt, records, intent, pref_lang)
                    if pref_lang != "en":
                        try:
                            fallback_text = self.translate_from_english(fallback_text, pref_lang)
                        except Exception:
                            pass
                    successful_res = {
                        "provider": "GauShakthi AI",
                        "response": fallback_text,
                        "language": pref_lang,
                        "tokens_used": len(clean_prompt.split()) + len(fallback_text.split()),
                        "model": "local-fallback-v1",
                        "latency_ms": int((time.time() - start_time) * 1000),
                        "citations": ["Local Master Dataset Index"],
                    }

                # Update memory state
                breed_col = next((k for k in records[0].keys() if k.lower() in ("suitable_breeds", "breed_name", "breed")), None)
                if intent == "breed":
                    state["previous_breed"] = records[0].get(breed_col or "Breed_Name")
                elif intent == "disease":
                    state["previous_disease"] = records[0].get("Disease_Name")
                elif intent == "feed":
                    state["previous_feed"] = records[0].get("Feed_Name") or records[0].get("Feed_Category")
                elif intent == "vaccination":
                    state["previous_vaccination"] = records[0].get("Vaccine_Name")
                elif intent == "climate":
                    state["previous_climate"] = records[0].get(breed_col or "Suitable_Breeds") or records[0].get("Climate_Type")

                # Update history cache
                if conversation_id:
                    if conversation_id not in self.history_cache:
                        self.history_cache[conversation_id] = []
                    self.history_cache[conversation_id].append({"role": "user", "content": clean_prompt})
                    self.history_cache[conversation_id].append({"role": "assistant", "content": successful_res["response"]})

                self._log_transaction(clean_prompt, pref_lang, english_prompt, resolved_english_prompt, msg_category, intent, dataset_used, records, successful_res, start_time, response_source="Dataset + Gemini" if not gemini_failed else "Dataset (Offline Fallback)", context_len=len(context))
                return successful_res

            # If no records exist in dataset: call Gemini directly
            else:
                polite_notice = (
                    "Note: The user asked about a specific domain, but no matching database records were found in our master datasets. "
                    "Answer using general expert knowledge without hallucination."
                )
                formatted_user_prompt = f"[Verified Knowledge Database Context]\n{polite_notice}\n\nUser Question: {resolved_english_prompt}"
                system_prompt = prompt_builder.build_system_prompt(language=pref_lang)
                
                gemini_failed = False
                if not os.getenv("GEMINI_API_KEY"):
                    gemini_failed = True
                else:
                    try:
                        res = self.providers["gemini"].generate_completion(
                            user_prompt=formatted_user_prompt,
                            system_prompt=system_prompt,
                            conversation_history=context_history or self.history_cache.get(conversation_id, []),
                            language=pref_lang
                        )
                        latency_ms = int((time.time() - start_time) * 1000)
                        res["latency_ms"] = latency_ms
                        successful_res = res
                    except Exception as e:
                        logger.error(f"Gemini call failed for query without records: {e}")
                        gemini_failed = True
                        
                if gemini_failed:
                    if pref_lang == "ta":
                        fallback_text = "மன்னிக்கவும், தற்போது தகவல்கள் கிடைக்கவில்லை."
                    elif pref_lang == "hi":
                        fallback_text = "क्षमा करें, वर्तमान में कोई जानकारी उपलब्ध नहीं है।"
                    elif pref_lang == "tanglish":
                        fallback_text = "Sry, ippo details edhuvum available illai."
                    else:
                        fallback_text = "Sorry, no details found."
                        
                    successful_res = {
                        "provider": "GauShakthi AI",
                        "response": fallback_text,
                        "language": pref_lang,
                        "tokens_used": len(clean_prompt.split()) + len(fallback_text.split()),
                        "model": "local-fallback-v1",
                        "latency_ms": int((time.time() - start_time) * 1000),
                        "citations": [],
                    }
                else:
                    # Translate final response back to selected language
                    if pref_lang != "en":
                        successful_res["response"] = self.translate_from_english(successful_res["response"], pref_lang)

                if conversation_id:
                    if conversation_id not in self.history_cache:
                        self.history_cache[conversation_id] = []
                    self.history_cache[conversation_id].append({"role": "user", "content": clean_prompt})
                    self.history_cache[conversation_id].append({"role": "assistant", "content": successful_res["response"]})

                self._log_transaction(clean_prompt, pref_lang, english_prompt, resolved_english_prompt, msg_category, intent, dataset_used, records, successful_res, start_time, response_source="Gemini only" if not gemini_failed else "Offline Fallback")
                return successful_res

        # 10. Call Gemini for other categories (casual, general knowledge, unknown)
        else:
            intent = "general"
            records = []
            dataset_used = "None (Conversational)"
            system_prompt = prompt_builder.build_system_prompt(language=pref_lang)
            formatted_user_prompt = f"User Message: {resolved_english_prompt}"
            
            gemini_failed = False
            if not os.getenv("GEMINI_API_KEY"):
                gemini_failed = True
            else:
                try:
                    res = self.providers["gemini"].generate_completion(
                        user_prompt=formatted_user_prompt,
                        system_prompt=system_prompt,
                        conversation_history=context_history or self.history_cache.get(conversation_id, []),
                        language=pref_lang
                    )
                    latency_ms = int((time.time() - start_time) * 1000)
                    res["latency_ms"] = latency_ms
                    successful_res = res
                except Exception as e:
                    logger.error(f"Gemini call failed for general chat: {e}")
                    gemini_failed = True
                    
            if gemini_failed:
                fallback_text = local_greetings.get(pref_lang, local_greetings["en"])
                successful_res = {
                    "provider": "GauShakthi AI",
                    "response": fallback_text,
                    "language": pref_lang,
                    "tokens_used": len(clean_prompt.split()) + len(fallback_text.split()),
                    "model": "local-fallback-v1",
                    "latency_ms": int((time.time() - start_time) * 1000),
                    "citations": [],
                }
            else:
                if pref_lang != "en":
                    successful_res["response"] = self.translate_from_english(successful_res["response"], pref_lang)

            if conversation_id:
                if conversation_id not in self.history_cache:
                    self.history_cache[conversation_id] = []
                self.history_cache[conversation_id].append({"role": "user", "content": clean_prompt})
                self.history_cache[conversation_id].append({"role": "assistant", "content": successful_res["response"]})

            self._log_transaction(clean_prompt, pref_lang, english_prompt, resolved_english_prompt, msg_category, intent, dataset_used, records, successful_res, start_time, response_source="Gemini only" if not gemini_failed else "Offline Fallback")
            return successful_res

rag_service_instance = RAGService()
