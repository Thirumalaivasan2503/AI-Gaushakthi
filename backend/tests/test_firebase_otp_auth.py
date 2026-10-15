import os
import sys
import uuid

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import pytest
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def _random_mobile():
    num = int(uuid.uuid4().int % 10000000)
    return f"+9198{num:07d}"

def test_firebase_login_auto_register_farmer():
    mobile = _random_mobile()
    dev_token = f"dev_firebase_id_token_{uuid.uuid4().hex[:8]}"

    payload = {
        "id_token": dev_token,
        "mobile": mobile,
        "full_name": "Velusamy Farmer",
        "device_info": "Chrome on Android Mobile",
    }

    response = client.post("/auth/firebase-login", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "success"
    
    resp_data = data["data"]
    assert "access_token" in resp_data
    assert "refresh_token" in resp_data
    assert resp_data["role"] == "farmer"
    
    farmer = resp_data["farmer_profile"]
    assert farmer["mobile"] == mobile
    assert farmer["full_name"] == "Velusamy Farmer"
    assert farmer["status"] == "active"

def test_firebase_login_existing_farmer():
    mobile = _random_mobile()
    dev_token_1 = f"dev_firebase_id_token_{uuid.uuid4().hex[:8]}"

    # First login (creates farmer)
    resp1 = client.post("/auth/firebase-login", json={
        "id_token": dev_token_1,
        "mobile": mobile,
        "full_name": "Ramu Selvam",
    })
    assert resp1.status_code == 200
    user_id_1 = resp1.json()["data"]["user_id"]

    # Second login (existing farmer)
    dev_token_2 = f"dev_firebase_id_token_{uuid.uuid4().hex[:8]}"
    resp2 = client.post("/auth/firebase-login", json={
        "id_token": dev_token_2,
        "mobile": mobile,
        "full_name": "Ramu Selvam",
    })
    assert resp2.status_code == 200
    user_id_2 = resp2.json()["data"]["user_id"]

    assert user_id_1 == user_id_2

def test_firebase_token_refresh_and_logout():
    mobile = _random_mobile()
    dev_token = f"dev_firebase_id_token_{uuid.uuid4().hex[:8]}"

    login_resp = client.post("/auth/firebase-login", json={
        "id_token": dev_token,
        "mobile": mobile,
        "full_name": "Karthik Farmer",
    })
    assert login_resp.status_code == 200
    refresh_token = login_resp.json()["data"]["refresh_token"]

    # Refresh JWT Access Token
    refresh_resp = client.post("/auth/refresh", json={"refresh_token": refresh_token})
    assert refresh_resp.status_code == 200
    assert "access_token" in refresh_resp.json()["data"]

    # Logout
    logout_resp = client.post("/auth/logout")
    assert logout_resp.status_code == 200
