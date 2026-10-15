from fastapi import APIRouter
from app.schemas.schemas import APIResponse

router = APIRouter(tags=["Health"])

@router.get("/health", response_model=APIResponse)
def health_check():
    return APIResponse(
        status="healthy",
        message="PasuMitra Indigenous Livestock Auth Service is online and healthy",
        data={
            "service": "authentication_backend",
            "version": "2.0.0",
            "database": "connected",
        },
    )
