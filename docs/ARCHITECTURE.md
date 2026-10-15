# Software Architecture Document (SAD)

## 1. Executive Summary

The **PasuMitra AI Indigenous Livestock Breed System** is built on an enterprise-grade Clean Architecture pattern separating domain entities, use-case interactors, presentation controllers, and remote/local data repositories.

---

## 2. System Architecture Diagram

```mermaid
graph TD
    Client[Flutter Mobile Client] -->|REST / JSON| Nginx[Nginx Reverse Proxy]
    Nginx -->|Gzip / HTTP| FastAPI[FastAPI Backend Server]
    FastAPI -->|ORM queries| Postgres[(PostgreSQL 15 Database)]
    FastAPI -->|Joblib Predict| ML[26-Feature ML Pipeline]
    FastAPI -->|API Adapters| LLM[LLM Engine: Gemini / GPT-4o / Claude]
    Client -->|Local Caching| SQLite[(SQLite Offline Store)]
```

---

## 3. Entity-Relationship (ER) Diagram

```mermaid
erDiagram
    USERS ||--o{ FARMER_PROFILES : "has profile"
    USERS ||--o{ RECOMMENDATION_HISTORY : "requests"
    FARMER_PROFILES ||--o{ LIVESTOCK : "owns"
    USERS ||--o{ NOTIFICATIONS : "receives"

    USERS {
        uuid id PK
        string full_name
        string mobile
        string email
        string role
        boolean is_active
    }

    FARMER_PROFILES {
        uuid id PK
        uuid user_id FK
        string state
        string district
        string village
        numeric land_holding_acres
    }

    LIVESTOCK {
        uuid id PK
        uuid farmer_profile_id FK
        string animal_tag_id
        string breed
        numeric age_years
        numeric weight_kg
    }

    RECOMMENDATION_HISTORY {
        uuid id PK
        uuid user_id FK
        string recommended_breed
        numeric confidence_score
        jsonb xai_rationale
    }
```

---

## 4. Sequence Diagram: AI Recommendation Request

```mermaid
sequenceDiagram
    autonumber
    actor Farmer
    participant App as Flutter Client
    participant SQLite as Local SQLite Cache
    participant API as FastAPI Backend
    participant ML as ML Service Engine
    participant LLM as Gemini LLM Provider

    Farmer->>App: Submits Farm Profile & Climate Rations
    App->>API: POST /api/predict (26 Features)
    alt Network Available
        API->>ML: Run Scaler & HistGradientBoosting Model
        ML-->>API: Breed Prediction + Confidence Scores
        API->>LLM: Generate Multilingual XAI Rationale
        LLM-->>API: Explainable Rationale + Citations
        API-->>App: JSON Recommendation Response
        App->>SQLite: Cache Recommendation Locally
    else Offline Mode
        App->>SQLite: Load Cached Breed Matrix
        SQLite-->>App: Fallback Offline Recommendation
    end
    App-->>Farmer: Render Recommendation & 5-Year Profit Chart
```

---

## 5. Deployment Architecture Diagram

```mermaid
graph LR
    subgraph Cloud Container Environment
        Nginx[Nginx Reverse Proxy :80] --> FastAPI[FastAPI App Workers :8000]
        FastAPI --> Postgres[(PostgreSQL 15 DB :5432)]
    end
    subgraph Client Mobile Hardware
        FlutterApp[Flutter App v3.2.0] --> SQLite[(Local SQLite Cache)]
    end
    FlutterApp -->|HTTPS / TLS| Nginx
```
