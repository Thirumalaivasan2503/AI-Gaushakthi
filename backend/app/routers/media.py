from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter(prefix="/api/v1/media", tags=["Media Upload Management"])

class MediaUploadResponse(BaseModel):
    media_id: str = "med_5501"
    file_url: str = "https://storage.googleapis.com/pasumitra-ai-bucket/uploads/vaccine_cert.pdf"
    status: str = "uploaded"

@router.post("/upload")
def upload_media():
    return {
        "status": "success",
        "message": "File compressed and uploaded to cloud storage.",
        "data": MediaUploadResponse().model_dump(),
    }
