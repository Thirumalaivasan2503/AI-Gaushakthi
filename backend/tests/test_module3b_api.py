import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import pytest
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_weather_api():
    response = client.get("/api/v1/weather/current?district=Coimbatore")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "success"
    assert "temperature_c" in data["data"]
    assert "heat_index_thi" in data["data"]

def test_notifications_api():
    response = client.get("/api/v1/notifications")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "success"
    assert len(data["data"]) >= 1

def test_media_upload_api():
    response = client.post("/api/v1/media/upload")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "success"
    assert "media_id" in data["data"]

def test_sync_push_api():
    payload = {
        "client_queue": [
            {"id": "q1", "action": "CREATE_ANIMAL", "payload": {"name": "Valli"}}
        ]
    }
    response = client.post("/api/v1/sync/push", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "success"
    assert data["processed_items_count"] == 1

def test_analytics_dashboard_api():
    response = client.get("/api/v1/analytics/dashboard")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "success"
    assert "model_accuracy" in data["data"]

def test_settings_api():
    response = client.get("/api/v1/settings")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "success"
    assert "theme_mode" in data["data"]
