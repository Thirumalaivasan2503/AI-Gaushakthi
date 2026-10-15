from fastapi import APIRouter
from pydantic import BaseModel
from typing import Optional

router = APIRouter(prefix="/api/v1/vet", tags=["Veterinary Expert System"])

class ConsultationRequest(BaseModel):
    farmer_id: str
    animal_id: str
    consultation_type: str = "Video" # Video, Audio, Chat
    preferred_slot: str = "Today 04:00 PM"
    clinical_notes: Optional[str] = None

@router.get("/reports")
def get_pending_vet_reports():
    return {
        "status": "success",
        "data": [
            {
                "report_id": "rep_901",
                "farmer_name": "Ramesh Kumar",
                "animal_id": "KANG-01",
                "submitted_at": "2024-08-01 10:15 AM",
                "severity": "Low",
                "status": "Pending Review",
                "uploaded_image_url": "https://storage.googleapis.com/pasumitra-ai-bucket/reports/cow_skin.jpg",
                "notes": "Farmer reported mild appetite drop.",
            }
        ],
    }

@router.post("/consultations")
def schedule_consultation(req: ConsultationRequest):
    return {
        "status": "created",
        "message": "Veterinary consultation scheduled successfully",
        "data": {
            "appointment_id": "apt_7788",
            "type": req.consultation_type,
            "slot": req.preferred_slot,
            "vet_name": "Dr. Ananya Sharma (Vet Expert)",
        },
    }

@router.get("/diseases")
def get_disease_database():
    return {
        "status": "success",
        "data": [
            {
                "id": "dis_1",
                "name": "Foot and Mouth Disease (FMD)",
                "symptoms": ["High Fever", "Blisters on Hooves and Tongue", "Excess Salivation"],
                "causes": "Aphthovirus Infection",
                "severity": "High",
                "treatment": "Antiseptic foot wash, Oxytetracycline spray, B-complex",
                "recovery_period": "14-21 Days",
                "is_emergency": True,
                "government_advisory": "Isolate infected animals immediately and notify District Vet Officer.",
            },
            {
                "id": "dis_2",
                "name": "Lumpy Skin Disease (LSD)",
                "symptoms": ["Nodular Skin Lesions", "Fever", "Swollen Lymph Nodes"],
                "causes": "Capripoxvirus (Vector Transmission via Flies/Ticks)",
                "severity": "High",
                "treatment": "Symptomatic treatment, Neem paste, Isolation",
                "recovery_period": "21-30 Days",
                "is_emergency": True,
                "government_advisory": "Ring vaccination drive active across state.",
            },
        ],
    }
