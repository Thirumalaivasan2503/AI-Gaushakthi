from fastapi import APIRouter

router = APIRouter(prefix="/api/v1/history", tags=["Recommendation History"])

@router.get("/recommendations")
def get_recommendation_history():
    return {
        "status": "success",
        "data": [
            {
                "id": "rec_001",
                "recommended_breed": "Kangayam Cattle",
                "confidence_score": 96.8,
                "productivity_goal": "Draft & Tillage",
                "timestamp": "2024-08-01 10:30:00",
            },
            {
                "id": "rec_002",
                "recommended_breed": "Sahiwal Cow",
                "confidence_score": 95.4,
                "productivity_goal": "Milk Production",
                "timestamp": "2024-07-28 14:15:00",
            },
        ],
    }
