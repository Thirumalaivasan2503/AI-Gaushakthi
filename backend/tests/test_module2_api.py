import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import pytest
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_ml_prediction_endpoint():
    payload = {
        "farm_size_acres": 5.0,
        "average_temp_c": 38.5,
        "annual_rainfall_mm": 600.0,
        "productivity_goal": "Draft & Tillage"
    }
    response = client.post("/api/v1/predict", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "success"
    assert "recommended_breed" in data["data"]
    assert "feature_importance_breakdown" in data["data"]

def test_breeds_endpoint():
    response = client.get("/api/v1/breeds")
    assert response.status_code == 200
    data = response.json()
    assert len(data["data"]) >= 3

def test_vet_diseases_endpoint():
    response = client.get("/api/v1/vet/diseases")
    assert response.status_code == 200
    data = response.json()
    assert len(data["data"]) >= 2

def test_knowledge_articles_endpoint():
    response = client.get("/api/v1/knowledge/articles")
    assert response.status_code == 200
    data = response.json()
    assert len(data["data"]) >= 2
