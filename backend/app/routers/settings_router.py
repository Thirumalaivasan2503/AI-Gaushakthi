from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter(prefix="/api/v1/settings", tags=["Application Settings"])

class UserSettingsRequest(BaseModel):
    theme_mode: str = "system" # light, dark, system
    language: str = "en" # en, ta, hi
    push_notifications_enabled: bool = True
    weather_alerts_enabled: bool = True
    offline_sync_wifi_only: bool = False

@router.get("")
def get_settings():
    return {
        "status": "success",
        "data": UserSettingsRequest().model_dump(),
    }

@router.post("")
def update_settings(req: UserSettingsRequest):
    return {
        "status": "success",
        "message": "User settings updated.",
        "data": req.model_dump(),
    }
