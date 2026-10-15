from fastapi import APIRouter

router = APIRouter(prefix="/api/v1/knowledge", tags=["Knowledge Hub & Govt Schemes"])

@router.get("/articles")
def get_knowledge_articles():
    return {
        "status": "success",
        "data": [
            {
                "id": "art_1",
                "title": "Summer Care Guide for Kangayam & Zebu Cattle",
                "category": "Seasonal Recommendations",
                "read_time": "5 min read",
                "summary": "Provide shade, mineral salt licks, and fresh borewell water 4 times daily to maintain heat resilience.",
                "author": "Dr. Ananya Sharma",
            },
            {
                "id": "art_2",
                "title": "Ethno-Veterinary Practices for Bovine Mastitis Prevention",
                "category": "Traditional Herbal Medicine",
                "read_time": "7 min read",
                "summary": "Application of Aloe vera, Turmeric, and Calcium Hydroxide paste reduces udder swelling in native cows.",
                "author": "AgriTech Advisory Board",
            },
        ],
    }

@router.get("/schemes")
def get_government_schemes():
    return {
        "status": "success",
        "data": [
            {
                "scheme_name": "Rashtriya Gokul Mission (RGM)",
                "offered_by": "Ministry of Fisheries, Animal Husbandry & Dairying",
                "subsidy": "Up to 50% capital subsidy for native breed conservation units",
                "eligibility": "Farmers owning indigenous Kangayam, Gir, or Sahiwal cattle",
                "apply_url": "https://dahd.nic.in/schemes",
            },
            {
                "scheme_name": "National Livestock Mission (NLM) - Goat Breeding",
                "offered_by": "Department of Animal Husbandry",
                "subsidy": "50% subsidy up to ₹10 Lakhs for 100+10 goat breeding farms",
                "eligibility": "Individual farmers & SHGs",
                "apply_url": "https://nlm.udyamimitra.in",
            },
        ],
    }
