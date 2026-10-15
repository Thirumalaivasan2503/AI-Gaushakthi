import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import pytest
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_assistant_chat_api():
    payload = {"message": "Explain Kangayam breed", "language": "en", "provider": "Gemini 2.5 Flash"}
    response = client.post("/api/v1/assistant/chat", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert "response" in data
    assert "provider" in data
    assert "processing_time" in data
    assert "timestamp" in data
    assert "conversation_id" in data

def test_assistant_chat_api_empty_message():
    payload = {"message": "   ", "language": "en"}
    response = client.post("/api/v1/assistant/chat", json=payload)
    assert response.status_code == 400
    data = response.json()
    assert data["success"] is False
    assert data["error"] == "Bad Request"
    assert "details" in data
    assert "timestamp" in data

def test_assistant_chat_api_validation_error():
    # Sending missing message parameter to trigger RequestValidationError
    payload = {"language": "en"}
    response = client.post("/api/v1/assistant/chat", json=payload)
    assert response.status_code == 400
    data = response.json()
    assert data["success"] is False
    assert data["error"] == "Validation Error"
    assert "details" in data
    assert "timestamp" in data

def test_assistant_chat_api_direct_alias():
    payload = {"message": "Explain Kangayam breed", "language": "en"}
    response = client.post("/api/chat", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert "response" in data
    assert "provider" in data
    assert "conversation_id" in data

def test_vision_analyze_api():
    payload = {"image_url": "https://storage.googleapis.com/pasumitra-ai-bucket/lesion.jpg", "image_type": "lesion"}
    response = client.post("/api/v1/vision/analyze", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "success"
    assert "flagged_for_vet_review" in data["data"]

def test_schemes_search_api():
    response = client.get("/api/v1/schemes/search?query=Gokul")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "success"
    assert len(data["data"]) >= 1
