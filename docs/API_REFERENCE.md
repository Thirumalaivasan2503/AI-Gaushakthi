# PasuMitra AI API Reference Guide

All API endpoints are prefixed with `/api/v1/` or `/api/` and respond with JSON.

---

## Endpoint Summary Matrix

| Category | Endpoint | Method | Description |
| :--- | :--- | :--- | :--- |
| **System** | `/health` | `GET` | System health check and uptime status |
| **Auth** | `/api/v1/auth/register` | `POST` | Register a new user |
| **Auth** | `/api/v1/auth/login` | `POST` | Authenticate user with Email/Mobile |
| **ML Predict** | `/api/predict` | `POST` | Execute 26-feature ML breed prediction |
| **ML Status** | `/api/model/status` | `GET` | Active model version & joblib metadata |
| **AI Assistant** | `/api/v1/assistant/chat` | `POST` | Multilingual LLM conversation |
| **Vision** | `/api/v1/vision/analyze` | `POST` | Computer vision image quality check |
| **Weather** | `/api/v1/weather/current` | `GET` | Current agronomic weather & THI index |
| **Schemes** | `/api/v1/schemes/search` | `GET` | Search Government livestock schemes |
| **Sync** | `/api/v1/sync/push` | `POST` | Process offline background sync queue |
| **Analytics** | `/api/v1/analytics/dashboard` | `GET` | System KPI and model metrics |
| **Settings** | `/api/v1/settings` | `GET` / `POST` | User app preferences |
