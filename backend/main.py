import os
import sys
import logging

# Ensure backend root and project root are on sys.path
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(BASE_DIR)
if BASE_DIR not in sys.path:
    sys.path.insert(0, BASE_DIR)
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.core.config import settings
from app.database.database import Base, engine
from app.models import models

from app.routers import (
    auth, users, health, prediction, breeds, veterinary,
    knowledge, ml_router, weather, notifications, history,
    media, sync, analytics, settings_router, assistant, vision, schemes
)

# Configure Logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("PasuMitraAuthBackend")

from sqlalchemy import text

# Initialize DB Tables
Base.metadata.create_all(bind=engine)

# Auto-migrate SQLite schema for Farmer OTP columns
with engine.connect() as conn:
    for col_def in [
        ("firebase_uid", "VARCHAR(128)"),
        ("status", "VARCHAR(20) DEFAULT 'active'"),
        ("device_info", "TEXT"),
        ("last_login", "DATETIME"),
    ]:
        try:
            conn.execute(text(f"ALTER TABLE users ADD COLUMN {col_def[0]} {col_def[1]};"))
            conn.commit()
            logger.info("Migrated users table: added column %s", col_def[0])
        except Exception:
            pass  # Column already exists

from app.services.breed_master_service import BreedMasterService
from app.services.feed_master_service import FeedMasterService
from app.services.disease_master_service import DiseaseMasterService
from app.services.vaccination_master_service import VaccinationMasterService
from app.services.climate_master_service import ClimateMasterService
from app.services.economics_master_service import EconomicsMasterService
from app.services.dataset_prediction_service import DatasetPredictionService
from app.services.llm.dataset_loader import DatasetLoader
from app.routers import feed, diseases, vaccinations, climate, economics

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    description="FastAPI Production Backend for Indigenous Livestock Breed Recommendation System.",
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_url="/openapi.json",
)

@app.on_event("startup")
def startup_event():
    """
    Loads breed_master.csv, feed_master.csv, disease_master.csv, vaccination_master.csv, climate_master.csv, and economics_master.csv using Pandas during FastAPI startup
    and caches all datasets and Random Forest Joblib models in memory.
    """
    logger.info("Preloading all 7 CSV datasets for RAG chatbot...")
    DatasetLoader.load_all()
    logger.info("Initializing Breed Knowledge Base from breed_master.csv...")
    BreedMasterService.load_breed_master()
    logger.info("Initializing Feed Recommendation Base from feed_master.csv...")
    FeedMasterService.load_feed_master()
    logger.info("Initializing Disease Knowledge Base from disease_master.csv...")
    DiseaseMasterService.load_disease_master()
    logger.info("Initializing Vaccination Knowledge Base from vaccination_master.csv...")
    VaccinationMasterService.load_vaccination_master()
    logger.info("Initializing Climate Knowledge Base from climate_master.csv...")
    ClimateMasterService.load_climate_master()
    logger.info("Initializing Economics Knowledge Base from economics_master.csv...")
    EconomicsMasterService.load_economics_master()
    logger.info("Loading Random Forest Classifier & Preprocessor Joblib artifacts...")
    DatasetPredictionService.load_artifacts()

    # Verify Gemini connectivity at startup
    gemini_key = os.getenv("GEMINI_API_KEY")
    if gemini_key:
        try:
            import httpx
            url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={gemini_key}"
            payload = {"contents": [{"parts": [{"text": "ping"}]}]}
            res = httpx.post(url, json=payload, timeout=5.0)
            if res.status_code == 200:
                print("Gemini Connected")
            else:
                print("Gemini API Key Missing")
        except Exception:
            print("Gemini API Key Missing")
    else:
        print("Gemini API Key Missing")

# CORS Setup
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Global Exception Handlers
from fastapi.exceptions import RequestValidationError
from datetime import datetime, timezone

@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    logger.warning(f"Validation Error: {exc.errors()}")
    details = "; ".join([f"{'.'.join(str(p) for p in err['loc'])}: {err['msg']}" for err in exc.errors()])
    return JSONResponse(
        status_code=400,
        content={
            "success": False,
            "error": "Validation Error",
            "details": details,
            "timestamp": datetime.now(timezone.utc).isoformat(),
        },
    )

@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    logger.error(f"Unhandled Exception: {exc}", exc_info=True)
    return JSONResponse(
        status_code=500,
        content={
            "success": False,
            "error": "Internal Server Error",
            "details": str(exc),
            "timestamp": datetime.now(timezone.utc).isoformat(),
        },
    )

# Expose /api/chat directly as an endpoint alias
from app.routers.assistant import ChatRequest, chat_with_assistant

@app.post("/api/chat")
def api_chat_alias(req: ChatRequest):
    return chat_with_assistant(req)

# Include Routers
app.include_router(health.router)
app.include_router(auth.router)
app.include_router(users.router)
app.include_router(prediction.router)
app.include_router(breeds.router)
app.include_router(veterinary.router)
app.include_router(knowledge.router)
app.include_router(ml_router.router)
app.include_router(weather.router)
app.include_router(notifications.router)
app.include_router(history.router)
app.include_router(media.router)
app.include_router(sync.router)
app.include_router(analytics.router)
app.include_router(settings_router.router)
app.include_router(assistant.router)
app.include_router(vision.router)
app.include_router(schemes.router)
app.include_router(feed.router)
app.include_router(diseases.router)
app.include_router(vaccinations.router)
app.include_router(climate.router)
app.include_router(economics.router)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
