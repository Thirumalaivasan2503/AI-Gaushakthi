from fastapi import APIRouter
from typing import Optional

router = APIRouter(prefix="/api/v1/schemes", tags=["Government Scheme Hub"])

SCHEMES_DB = [
    {
        "id": "sch_01",
        "title": "Rashtriya Gokul Mission (RGM) Native Breed Subsidy",
        "level": "Central Government",
        "subsidy": "50% Capital Subsidy up to ₹50 Lakhs",
        "eligibility": "Farmers & FPOs establishing Kangayam, Gir, or Sahiwal multiplication units",
        "apply_url": "https://dahd.nic.in/",
        "portal_name": "DAHD Official Portal",
        "disclaimer": "Verify official details at government portal before applying.",
    },
    {
        "id": "sch_02",
        "title": "National Livestock Mission (NLM) Entrepreneurship Scheme",
        "level": "Central Government",
        "subsidy": "50% Subsidy up to ₹50 Lakhs for breeding farms",
        "eligibility": "Individual farmers rearing native cattle, goats (Malabari/Tellicherry), or sheep",
        "apply_url": "https://nlm.udyamimitra.in/",
        "portal_name": "NLM Udyamimitra Portal",
        "disclaimer": "Verify official details at government portal before applying.",
    },
    {
        "id": "sch_03",
        "title": "Tamil Nadu Native Breed Protection Incentive & Vaccination",
        "level": "State Government",
        "subsidy": "Free AI A2 Straws & ₹5,000 heifer birth incentive",
        "eligibility": "Farmers keeping registered Kangayam, Umblachery, or Bargur cattle in Tamil Nadu",
        "apply_url": "https://aah.tn.gov.in/",
        "portal_name": "TN Animal Husbandry Dept Portal",
        "disclaimer": "Verify official details at government portal before applying.",
    },
    {
        "id": "sch_04",
        "title": "NABARD Dairy Entrepreneurship & Native Breed Credit Support",
        "level": "Central / NABARD",
        "subsidy": "25% to 33.33% Capital Subsidy + Bank Credit",
        "eligibility": "Small and marginal farmers establishing native dairy units",
        "apply_url": "https://www.nabard.org/",
        "portal_name": "NABARD Official Website",
        "disclaimer": "Verify official details at government portal before applying.",
    },
]

@router.get("/search")
def search_schemes(query: Optional[str] = ""):
    if query:
        q = query.lower()
        matched = [s for s in SCHEMES_DB if q in s["title"].lower() or q in s["eligibility"].lower()]
        return {"status": "success", "data": matched}
    return {"status": "success", "data": SCHEMES_DB}
