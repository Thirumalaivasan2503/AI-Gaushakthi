import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import pytest
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_26_feature_predict_api():
    payload = {
        "farmer_age": 45,
        "state": "Tamil Nadu",
        "district": "Coimbatore",
        "climate_zone": "Semi-Arid Tropical",
        "average_temp_c": 38.5,
        "humidity_percent": 62.0,
        "annual_rainfall_mm": 650.0,
        "water_availability": "Abundant Borewell",
        "soil_type": "Red Loamy Soil",
        "farm_size_acres": 6.0,
        "available_budget_inr": 120000.0,
        "feed_budget_monthly_inr": 22000.0,
        "medical_budget_monthly_inr": 6000.0,
        "livestock_count": 5,
        "disease_history_count": 1,
        "vaccination_status": "Up-to-Date",
        "animal_health_status": "Healthy",
        "feed_type": "Co-4 Napier Grass & Stover",
        "feed_cost_monthly_inr": 18000.0,
        "productivity_goal": "Draft & Tillage",
        "milk_requirement_liters": 15.0,
        "breeding_goal": "Purebred Preservation",
        "organic_farming_preference": True,
        "maintenance_preference": "Low Maintenance",
        "sustainability_goal": "High Income ROI"
    }
    response = client.post("/api/predict", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "success"
    assert "recommended_breed" in data["data"]
    assert "alternative_breeds" in data["data"]
    assert "feature_importance_breakdown" in data["data"]

def test_model_status_api():
    response = client.get("/api/model/status")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "online"

def test_model_metrics_api():
    response = client.get("/api/model/metrics")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "success"

def test_recommendation_history_api():
    response = client.get("/api/recommendation/history")
    assert response.status_code == 200
    data = response.json()
    assert len(data["data"]) >= 2
