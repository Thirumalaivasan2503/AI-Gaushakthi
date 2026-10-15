"""
prompt_builder.py
=================
Central prompt engineering module for GauShakthi AI Livestock Assistant.

Provides:
  - build_system_prompt()      : Returns the full system instruction for the LLM.
  - build_user_message()       : Constructs the dynamic user turn from question + context.
  - retrieve_relevant_context(): Dynamically queries cached database master files.
  - format_history_for_gemini(): Formats chat history for Google Gemini API.
  - format_history_for_openai(): Formats chat history for OpenAI Chat Completions API.
  - format_history_for_claude(): Formats chat history for Anthropic Messages API.
"""

import logging
from typing import List, Dict, Optional

logger = logging.getLogger("PasuMitraPromptBuilder")

# Import the cached services to build context dynamically
try:
    from app.services.breed_master_service import BreedMasterService
    from app.services.feed_master_service import FeedMasterService
    from app.services.disease_master_service import DiseaseMasterService
    from app.services.vaccination_master_service import VaccinationMasterService
    from app.services.climate_master_service import ClimateMasterService
    from app.services.economics_master_service import EconomicsMasterService
except ImportError:
    from backend.app.services.breed_master_service import BreedMasterService
    from backend.app.services.feed_master_service import FeedMasterService
    from backend.app.services.disease_master_service import DiseaseMasterService
    from backend.app.services.vaccination_master_service import VaccinationMasterService
    from backend.app.services.climate_master_service import ClimateMasterService
    from backend.app.services.economics_master_service import EconomicsMasterService


# Language-specific greetings / instruction overrides
_LANG_OVERRIDES: Dict[str, str] = {
    "ta": (
        "தமிழில் மட்டுமே பதிலளி. "
        "தொழில்நுட்ப சொற்களை தமிழில் விளக்கு. "
        "ஒவ்வொரு கேள்விக்கும் குறிப்பிட்ட, தெளிவான பதில் தருக."
    ),
    "hi": (
        "केवल हिंदी में उत्तर दें। "
        "तकनीकी शब्दों को हिंदी में समझाएं। "
        "प्रत्येक प्रश्न का सटीक और स्पष्ट उत्तर दें।"
    ),
    "en": (
        "Answer in clear, professional English. "
        "Use precise agricultural and veterinary terminology where appropriate."
    ),
}


def build_system_prompt(language: str = "en") -> str:
    """
    Return the full system instruction for the GauShakthi Livestock AI Assistant.
    """
    lang_instruction = _LANG_OVERRIDES.get(language, _LANG_OVERRIDES["en"])
    
    lang_name_map = {
        "en": "English",
        "ta": "Tamil",
        "hi": "Hindi",
        "tanglish": "Tanglish (Tamil written in English script)"
    }
    selected_language = lang_name_map.get(language, language)

    return f"""You are GauShakthi AI.
You are a professional livestock assistant.
The user's preferred language is {selected_language}.
Always respond ONLY in that language.
Never switch to another language.
Never mention CSV files.
Never mention databases.
Never mention vector search.
Never mention knowledge retrieval.
Never mention internal processing.
Speak naturally like ChatGPT.
Be friendly.
Be conversational.
Be intelligent.
Be concise.

You are GauShakthi AI — a friendly, helpful, professional, and conversational livestock AI assistant. You speak naturally and write exactly like ChatGPT, Gemini, or Claude.

## YOUR PERSONALITY
- **Friendly & Conversational:** Speak directly to the farmer or veterinarian as a knowledgeable companion. Use simple, warm, and clear style.
- **Natural & Human-like:** Never sound robotic, like a formal report, or like standard database documentation.
- **Easy to Understand:** Explain concepts simply, using short paragraphs. Avoid over-explaining or repeating information.

## STRICT WRITING RULES
- **Never mention database internals:** Never say phrases like "according to our database", "based on our knowledge base", "retrieved records", "CSV", "record ID", "offline mode", "internal context", "verified information", "based on the retrieved information", etc. Use the provided context silently and invisibly to guide the factual accuracy of your answers. Act as if you naturally know these facts.
- **Never expose database structure:** Do not print column names, database IDs, developer messages, or raw key-value lists.
- **No repetitive boilerplate:** Do not repeat the same opening or ending sentences for every answer. Custom-tailor the introduction and closing naturally to fit the query.
- **Minimize disclaimers:** Avoid generic system warnings or vet disclaimers unless the question is explicitly about critical animal health, illness, symptoms, or medical treatment.
- **Direct Answers:** Answer only what the user asked. Give actionable, practical advice.

## SPECIALIZED DOMAIN SPECIALIZATION (Use internally for fact-checking)
1. **Indigenous Livestock Breeds** — Kangayam, Umblachery, Bargur, Punganur, Ongole, Gir, Sahiwal, Murrah buffalo, Bannur sheep, Attappady Black goat, etc.
2. **Veterinary Science** — disease diagnosis support, symptom triage, first-aid protocols, non-prescriptive medication guidance, zoonotic disease awareness.
3. **Feed & Nutrition Management** — green fodder, dry fodder, silage, total mixed ration (TMR), mineral supplementation.
4. **Disease Prevention & Biosecurity** — FMD, Lumpy Skin Disease, Brucellosis, Bovine TB, Black Quarter, Anthrax, PPR, CCPP, isolation protocols.
5. **Vaccination Schedules** — vaccination timings, routes of administration, dose requirements.
6. **Climate Suitability** — heat stress thresholds, breed-climate matching, drought resilience.
7. **Livestock Economics** — costs, income, ROI analysis, market linkage, subsidy schemes.

## LANGUAGE INSTRUCTION
{lang_instruction}
"""


def retrieve_relevant_context(user_question: str) -> str:
    """
    Search local cached datasets for breed, disease, vaccination, feed, climate,
    and economics records relevant to the user's question.
    """
    q_lower = user_question.lower()
    context_parts = []

    # 1. Match Breeds
    matched_breed = None
    try:
        breeds = BreedMasterService.get_all_breeds()
        for b in breeds:
            b_name = b["Breed_Name"].lower()
            # Handle token and phrase matching
            if b_name in q_lower or any(token in q_lower for token in b_name.split() if len(token) > 3 and token not in ("goat", "cow", "cattle")):
                matched_breed = b["Breed_Name"]
                context_parts.append(
                    f"[Breed Details for {b['Breed_Name']}]\n"
                    f"- Type: {b['Breed_Type']}, Origin: {b['Origin_State']}\n"
                    f"- Daily Milk Yield: {b['Milk_Yield_Liters_Day']} Liters, Meat Productivity: {b['Meat_Productivity']}\n"
                    f"- Disease Resistance: {b['Disease_Resistance']}, Climate Adaptability: {b['Climate_Adaptability']}\n"
                    f"- Description: {b['Description']}"
                )
                break
    except Exception as e:
        logger.error(f"Error retrieving breed context: {e}")

    # If breed matched, retrieve its economics and feed details
    if matched_breed:
        try:
            econ = EconomicsMasterService.get_economics_by_breed_name(matched_breed)
            if econ:
                context_parts.append(
                    f"[Economics/Financials for {matched_breed}]\n"
                    f"- Purchase Cost: INR {econ['Purchase_Cost_INR']}, Maintenance Cost: INR {econ['Monthly_Maintenance_Cost_INR']}/month\n"
                    f"- Expected Annual Income: INR {econ['Expected_Annual_Income_INR']}, Net Profit: INR {econ['Net_Profit_INR']}\n"
                    f"- ROI: {econ['ROI_Percentage']}%, Break-even Period: {econ['Break_even_Period_Months']}\n"
                    f"- Farming Purpose: {econ['Farming_Type']}, Recommended For: {econ['Recommended_Farmer_Type']}"
                )
        except Exception as e:
            logger.error(f"Error retrieving economics context: {e}")

        try:
            feed = FeedMasterService.get_feed_by_breed_name(matched_breed)
            if feed:
                context_parts.append(
                    f"[Feed Recommendations for {matched_breed}]\n"
                    f"- Type: {feed['Feed_Type']}, Water: {feed['Water_Requirement']}\n"
                    f"- Morning Feed: {feed['Morning_Feed']}, Evening Feed: {feed['Evening_Feed']}\n"
                    f"- Mineral Mixture: {feed['Mineral_Mixture']}, Daily Feed Cost: INR {feed['Daily_Feed_Cost_INR']}\n"
                    f"- Nutrition: Protein {feed['Protein_Percentage']}, Fiber {feed['Fiber_Percentage']}, Energy {feed['Energy_Level']}"
                )
        except Exception as e:
            logger.error(f"Error retrieving feed context: {e}")

    # 2. Match Diseases
    matched_disease = None
    try:
        diseases = DiseaseMasterService.get_all_diseases()
        unique_diseases = {}
        for d in diseases:
            d_name = d["Disease_Name"].lower()
            if d_name not in unique_diseases:
                unique_diseases[d_name] = d
        
        abbrev_map = {
            "fmd": "foot and mouth disease",
            "lsd": "lumpy skin disease",
            "ppr": "ppr",
            "tb": "bovine tuberculosis"
        }
        for abbrev, full_name in abbrev_map.items():
            if abbrev in q_lower.split():
                matched_disease = full_name
                break

        if not matched_disease:
            for d_name in unique_diseases:
                if d_name in q_lower or any(token in q_lower for token in d_name.split() if len(token) > 3 and token not in ("and", "the", "disease")):
                    matched_disease = d_name
                    break

        if matched_disease:
            dis_info = DiseaseMasterService.get_disease_by_name(matched_disease)
            if dis_info:
                context_parts.append(
                    f"[Disease Info for {dis_info['Disease_Name']}]\n"
                    f"- Species Affected: {dis_info['Affected_Species']}, Category: {dis_info['Disease_Category']}\n"
                    f"- Symptoms: {dis_info['Symptoms']}\n"
                    f"- Cause: {dis_info['Cause']}, Severity: {dis_info['Severity']}, Risk Level: {dis_info['Risk_Level']}\n"
                    f"- Transmission: {dis_info['Transmission_Mode']}, Climate Risk: {dis_info['Climate_Risk']}\n"
                    f"- Prevention: {dis_info['Prevention']}, Treatment: {dis_info['Treatment']}\n"
                    f"- Estimated Treatment Cost: INR {dis_info['Estimated_Treatment_Cost_INR']}\n"
                    f"- Recommended Action: {dis_info['Recommended_Action']}"
                )
                
                # Fetch vaccinations for this disease
                vacs = VaccinationMasterService.get_vaccinations_by_disease(dis_info['Disease_Name'])
                if vacs:
                    vac_lines = []
                    for v in vacs[:3]:
                        vac_lines.append(
                            f"  * Vaccine: {v['Vaccine_Name']}, Dose: {v['Dose']}, Route: {v['Administration_Route']}, Season: {v['Recommended_Season']}"
                        )
                    context_parts.append(
                        f"[Vaccination Details for {dis_info['Disease_Name']}]\n" + "\n".join(vac_lines)
                    )
    except Exception as e:
        logger.error(f"Error retrieving disease/vaccination context: {e}")

    # 3. Match States/Climate
    try:
        states = ["tamil nadu", "gujarat", "punjab", "andhra pradesh", "kerala"]
        matched_state = None
        for s in states:
            if s in q_lower:
                matched_state = s
                break
        if matched_state:
            climates = ClimateMasterService.get_climate_by_state(matched_state)
            if climates:
                c = climates[0]
                context_parts.append(
                    f"[Climate and Environment for {c['State']} ({c['District']} district)]\n"
                    f"- Climate Type: {c['Climate_Type']}, Avg Temp: {c['Avg_Temperature_C']}C, Avg Humidity: {c['Avg_Humidity_Percent']}%\n"
                    f"- Annual Rainfall: {c['Annual_Rainfall_mm']}mm, Water Availability: {c['Water_Availability']}\n"
                    f"- Drought Risk: {c['Drought_Risk']}, Flood Risk: {c['Flood_Risk']}\n"
                    f"- Suitable Breeds: {c['Suitable_Breeds']}"
                )
    except Exception as e:
        logger.error(f"Error retrieving climate context: {e}")

    # 4. Keyword Fallback Searches
    if not context_parts:
        if any(w in q_lower for w in ["feed", "fodder", "diet", "nutrition", "silage", "ration"]):
            try:
                feeds = FeedMasterService.get_all_feeds()
                if feeds:
                    feed_lines = [f"- {f['Breed_Name']}: Morning: {f['Morning_Feed']}, Evening: {f['Evening_Feed']}, Mixture: {f['Mineral_Mixture']}" for f in feeds[:2]]
                    context_parts.append("[Sample Feed Recommendations]\n" + "\n".join(feed_lines))
            except Exception:
                pass
        
        if any(w in q_lower for w in ["vaccine", "vaccination", "schedule", "immuniz"]):
            try:
                vacs = VaccinationMasterService.get_all_vaccinations()
                if vacs:
                    vac_lines = [f"- Disease: {v['Disease']} -> Vaccine: {v['Vaccine_Name']} (Dose: {v['Dose']}, Route: {v['Administration_Route']})" for v in vacs[:3]]
                    context_parts.append("[National Vaccination Program Info]\n" + "\n".join(vac_lines))
            except Exception:
                pass

        if any(w in q_lower for w in ["scheme", "subsidy", "subsidized", "loan", "pmfby", "rgm", "nlm", "rkvy"]):
            context_parts.append(
                "[Government Schemes Info]\n"
                "- Rashtriya Gokul Mission (RGM): Provides 50% capital subsidy (up to Rs. 50 Lakhs) for native/indigenous breed development units.\n"
                "- National Livestock Mission (NLM): Subsidies for feed & fodder development, goat/sheep/poultry farming.\n"
                "- Rashtriya Krishi Vikas Yojana (RKVY): Financial assistance for infrastructure and animal husbandry extension.\n"
                "- PM Fasal Bima Yojana (PMFBY) & Livestock Insurance: Cattle insurance with subsidized premium rates."
            )

    return "\n\n".join(context_parts) if context_parts else ""


def build_user_message(
    user_question: str,
    context: Optional[str] = None,
    language: str = "en",
) -> str:
    """
    Construct the final user message string that is sent to the LLM.
    """
    parts = []

    if context and context.strip():
        parts.append(f"[Verified Knowledge Database Context]\n{context.strip()}\n")
    else:
        parts.append("[Verified Knowledge Database Context]\nNo direct verified database records exist for this query.\n")

    parts.append(f"User Question: {user_question.strip()}")

    return "\n".join(parts)


def format_history_for_openai(
    history: List[Dict[str, str]],
) -> List[Dict[str, str]]:
    """
    Convert internal history format -> OpenAI messages list.
    """
    formatted = []
    for turn in history or []:
        role = turn.get("role", "").lower()
        content = turn.get("content", "").strip()
        if role in ("user", "assistant") and content:
            formatted.append({"role": role, "content": content})
    return formatted


def format_history_for_gemini(
    history: List[Dict[str, str]],
) -> List[Dict]:
    """
    Convert internal history format -> Gemini contents list.
    """
    formatted = []
    for turn in history or []:
        role = turn.get("role", "").lower()
        content = turn.get("content", "").strip()
        if not content:
            continue
        gemini_role = "model" if role == "assistant" else "user"
        formatted.append({"role": gemini_role, "parts": [{"text": content}]})
    return formatted


def format_history_for_claude(
    history: List[Dict[str, str]],
) -> List[Dict[str, str]]:
    """
    Convert internal history format -> Anthropic messages list.
    """
    return format_history_for_openai(history)
