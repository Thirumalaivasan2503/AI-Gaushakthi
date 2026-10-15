import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "../..")))

from fastapi import APIRouter
from pydantic import BaseModel
from typing import Optional, Dict, Any
from app.services.dataset_prediction_service import DatasetPredictionService

router = APIRouter(tags=["ML Recommendation Engine & Model Metrics"])

class PredictionRequest(BaseModel):
    farmer_name: Optional[str] = "Farmer"
    state: Optional[str] = "Tamil Nadu"
    district: Optional[str] = "Erode"
    species: Optional[str] = "Cattle"
    breed_purpose: Optional[str] = "Milk"
    primary_purpose: Optional[str] = "Milk"
    average_temperature: Optional[float] = 34.5
    max_temperature_c: Optional[float] = 34.5
    humidity: Optional[float] = 65.0
    humidity_percent: Optional[float] = 65.0
    rainfall: Optional[float] = 720.0
    annual_rainfall_mm: Optional[float] = 720.0
    climate_type: Optional[str] = "Semi-Arid"
    climate_zone: Optional[str] = "Semi-Arid"
    farm_size: Optional[float] = 4.5
    land_holding_acres: Optional[float] = 4.5
    farming_budget: Optional[float] = 18000.0
    feed_budget_monthly: Optional[float] = 18000.0
    medical_budget_monthly: Optional[float] = 5000.0
    disease_history: Optional[str] = "None"
    vaccination_status: Optional[str] = "Yes"
    feed_affordability: Optional[str] = "High"
    water_availability: Optional[str] = "Medium"
    productivity_goal: Optional[str] = "High Milk"
    soil_type: Optional[str] = "Red"
    organic_farming: Optional[str] = "Yes"

@router.post("/api/predict")
@router.post("/api/v1/predict")
@router.post("/api/v1/recommendation/predict")
def predict_livestock_breed(req: PredictionRequest):
    """
    Predicts optimal indigenous breed using Random Forest Classifier trained on
    backend/datasets/livestock_training_dataset.csv and automatically combines all 6 master datasets.
    """
    input_dict = req.model_dump()
    result = DatasetPredictionService.predict(input_dict)
    return {
        "status": "success",
        "message": "AI Random Forest breed recommendation & comprehensive master report generated successfully.",
        "data": result,
    }

@router.get("/api/model/metrics")
@router.get("/api/admin/metrics")
@router.get("/api/v1/model-metrics")
def get_model_evaluation_metrics():
    """
    Returns model evaluation metrics (Accuracy, Precision, Recall, F1 Score, Confusion Matrix, ROC-AUC)
    for display in the Admin Dashboard.
    """
    metrics = DatasetPredictionService.get_model_metrics()
    return {
        "status": "success",
        "data": metrics,
    }

@router.post("/api/v1/train-dataset")
def train_rf_dataset():
    """
    Triggers retraining of the Random Forest model on backend/datasets/livestock_training_dataset.csv
    and updates Joblib artifacts.
    """
    from app.machine_learning.train_rf_model import train_and_evaluate_rf_model
    metrics = train_and_evaluate_rf_model()
    DatasetPredictionService.load_artifacts()
    return {
        "status": "success",
        "message": "Random Forest model retrained and saved to backend/models/random_forest_model.joblib.",
        "data": metrics,
    }
