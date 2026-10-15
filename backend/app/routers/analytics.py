from fastapi import APIRouter

router = APIRouter(prefix="/api/v1/analytics", tags=["System Analytics"])

@router.get("/dashboard")
def get_analytics_dashboard():
    return {
        "status": "success",
        "data": {
            "model_accuracy": 79.33,
            "prediction_count_total": 1420,
            "farmer_growth_rate": "18.5%",
            "top_breed": "Kangayam Cattle",
            "disease_outbreaks_prevented": 38,
            "vaccination_coverage": "92.4%",
        },
    }
