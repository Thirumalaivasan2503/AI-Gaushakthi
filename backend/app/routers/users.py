from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database.database import get_db
from app.schemas.schemas import APIResponse, ProfileUpdate
from app.middleware.role_middleware import get_current_user_token_data
from app.repositories.user_repository import UserRepository

router = APIRouter(prefix="/users", tags=["Users & Profiles"])

@router.get("/me", response_model=APIResponse)
def get_current_user(
    token_data: dict = Depends(get_current_user_token_data),
    db: Session = Depends(get_db),
):
    user_id = token_data.get("sub")
    user = UserRepository.get_by_id(db, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User profile not found")
    return APIResponse(
        status="success",
        message="User details retrieved",
        data={
            "id": user.id,
            "full_name": user.full_name,
            "mobile": user.mobile,
            "email": user.email,
            "role": user.role,
            "language": user.language,
            "is_active": user.is_active,
        },
    )

@router.get("/profile", response_model=APIResponse)
def get_user_profile(
    token_data: dict = Depends(get_current_user_token_data),
    db: Session = Depends(get_db),
):
    return get_current_user(token_data, db)

@router.put("/profile", response_model=APIResponse)
def update_user_profile(
    data: ProfileUpdate,
    token_data: dict = Depends(get_current_user_token_data),
    db: Session = Depends(get_db),
):
    user_id = token_data.get("sub")
    user = UserRepository.get_by_id(db, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    if data.full_name:
        user.full_name = data.full_name
    if data.language:
        user.language = data.language
    db.commit()
    db.refresh(user)

    return APIResponse(
        status="success",
        message="User profile updated successfully",
        data={"id": user.id, "full_name": user.full_name, "language": user.language},
    )
