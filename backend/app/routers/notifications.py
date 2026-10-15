from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter(prefix="/api/v1/notifications", tags=["Firebase Push Notifications"])

class RegisterTokenRequest(BaseModel):
    fcm_token: str

@router.get("")
def get_notifications():
    return {
        "status": "success",
        "data": [
            {
                "id": "notif_01",
                "title": "Vaccination Reminder: FMD Booster Due",
                "body": "Your Kangayam Cattle (KANG-01) is due for FMD Booster vaccine in 5 days.",
                "category": "vaccination",
                "is_read": False,
                "created_at": "2024-08-01 09:00:00",
            },
            {
                "id": "notif_02",
                "title": "Weather Alert: High Heat Index Warning",
                "body": "Temperatures reaching 38°C in Coimbatore. Provide fresh borewell water & shade.",
                "category": "weather",
                "is_read": True,
                "created_at": "2024-07-31 16:30:00",
            },
        ],
    }

@router.post("/token")
def register_fcm_token(req: RegisterTokenRequest):
    return {
        "status": "success",
        "message": "FCM Push notification token registered successfully.",
    }
