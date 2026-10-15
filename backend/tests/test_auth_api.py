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

def _random_email():
    return f"user_{uuid.uuid4().hex[:6]}@pasumitra.org"

def test_health_check():
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"

def test_register_user():
    payload = {
        "full_name": "Sundareshan Farmer",
        "mobile": _random_mobile(),
        "email": _random_email(),
        "password": "Password123",
        "role": "ruralFarmer",
        "state": "Tamil Nadu",
        "district": "Coimbatore",
        "village": "Pollachi",
    }
    response = client.post("/auth/register", json=payload)
    assert response.status_code == 201
    data = response.json()
    assert data["status"] == "created"
    assert "access_token" in data["data"]

def test_login_email():
    email = _random_email()
    mobile = _random_mobile()
    
    # 1. Register first
    client.post("/auth/register", json={
        "full_name": "Email User",
        "mobile": mobile,
        "email": email,
        "password": "Password123",
        "role": "ruralFarmer"
    })

    # 2. Login
    response = client.post("/auth/login", json={"email": email, "password": "Password123"})
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "success"
    assert "access_token" in data["data"]

def test_login_mobile_and_otp():
    mobile = _random_mobile()

    # 1. Trigger mobile login OTP
    response = client.post("/auth/login/mobile", json={"mobile": mobile})
    assert response.status_code == 200

    # 2. Verify OTP
    verify_resp = client.post("/auth/verify-otp", json={"mobile": mobile, "otp": "123456"})
    assert verify_resp.status_code == 200
    data = verify_resp.json()
    assert data["status"] == "success"

def test_token_refresh():
    mobile = _random_mobile()
    login_resp = client.post("/auth/login/mobile", json={"mobile": mobile})
    refresh_token = login_resp.json()["data"]["refresh_token"]

    refresh_resp = client.post("/auth/refresh", json={"refresh_token": refresh_token})
    assert refresh_resp.status_code == 200
    data = refresh_resp.json()
    assert "access_token" in data["data"]

def test_get_user_profile():
    mobile = _random_mobile()
    login_resp = client.post("/auth/login/mobile", json={"mobile": mobile})
    token = login_resp.json()["data"]["access_token"]

    headers = {"Authorization": f"Bearer {token}"}
    profile_resp = client.get("/users/me", headers=headers)
    assert profile_resp.status_code == 200
    data = profile_resp.json()
    assert data["status"] == "success"
