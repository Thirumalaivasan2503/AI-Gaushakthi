from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database.database import get_db
from app.schemas.schemas import (
    UserRegister,
    UserLogin,
    UserLoginMobile,
    OTPVerify,
    FirebaseLoginRequest,
    RefreshTokenRequest,
    ForgotPasswordRequest,
    ResetPasswordRequest,
    TokenResponse,
    APIResponse,
)
from app.services.auth_service import AuthService
from app.repositories.user_repository import UserRepository

router = APIRouter(prefix="/auth", tags=["Authentication"])

@router.post("/firebase-login", response_model=APIResponse)
def firebase_login(data: FirebaseLoginRequest, db: Session = Depends(get_db)):
    """
    Verifies Firebase ID Token, auto-creates/fetches Farmer account, and returns JWT tokens.
    """
    token_resp = AuthService.login_with_firebase_token(
        db=db,
        id_token=data.id_token,
        mobile=data.mobile,
        full_name=data.full_name,
        device_info=data.device_info,
    )
    return APIResponse(
        status="success",
        message="Firebase OTP verified successfully. Farmer session initiated.",
        data=token_resp.model_dump(),
    )

@router.post("/register", response_model=APIResponse, status_code=status.HTTP_201_CREATED)
def register_user(data: UserRegister, db: Session = Depends(get_db)):
    token_resp = AuthService.register_user(db, data)
    return APIResponse(
        status="created",
        message="User account registered successfully",
        data=token_resp.model_dump(),
    )

@router.post("/login", response_model=APIResponse)
def login_email(data: UserLogin, db: Session = Depends(get_db)):
    token_resp = AuthService.login_email(db, data.email, data.password)
    return APIResponse(
        status="success",
        message="Login successful via email",
        data=token_resp.model_dump(),
    )

import random

@router.post("/request-otp", response_model=APIResponse)
def request_otp(data: UserLoginMobile, db: Session = Depends(get_db)):
    # Generate 6-digit OTP for Indian mobile verification
    otp_code = str(random.randint(100000, 999999))
    UserRepository.save_otp(db, data.mobile, otp_code)
    return APIResponse(
        status="success",
        message=f"OTP sent to Indian mobile number {data.mobile}",
        data={"otp": otp_code, "mobile": data.mobile, "full_name": data.full_name or "Ramu Selvam"},
    )

@router.post("/login/mobile", response_model=APIResponse)
def login_mobile(data: UserLoginMobile, db: Session = Depends(get_db)):
    token_resp = AuthService.login_mobile(db, data.mobile, data.password, full_name=data.full_name)
    otp_code = str(random.randint(100000, 999999))
    UserRepository.save_otp(db, data.mobile, otp_code)
    resp_data = token_resp.model_dump()
    resp_data["otp"] = otp_code
    return APIResponse(
        status="success",
        message="OTP sent to mobile number",
        data=resp_data,
    )

@router.post("/verify-otp", response_model=APIResponse)
def verify_otp(data: OTPVerify, db: Session = Depends(get_db)):
    token_resp = AuthService.verify_otp_and_login(db, data.mobile, data.otp, full_name=data.full_name)
    return APIResponse(
        status="success",
        message="OTP verified successfully. JWT access token generated.",
        data=token_resp.model_dump(),
    )

@router.post("/refresh", response_model=APIResponse)
def refresh_token(data: RefreshTokenRequest, db: Session = Depends(get_db)):
    token_resp = AuthService.refresh_access_token(db, data.refresh_token)
    return APIResponse(
        status="success",
        message="Access token refreshed",
        data=token_resp.model_dump(),
    )

@router.post("/logout", response_model=APIResponse)
def logout():
    return APIResponse(
        status="success",
        message="User logged out successfully",
        data={},
    )

@router.post("/forgot-password", response_model=APIResponse)
def forgot_password(data: ForgotPasswordRequest, db: Session = Depends(get_db)):
    UserRepository.save_otp(db, data.identity, "123456")
    return APIResponse(
        status="success",
        message=f"Password reset code sent to {data.identity}",
        data={},
    )

@router.post("/reset-password", response_model=APIResponse)
def reset_password(data: ResetPasswordRequest, db: Session = Depends(get_db)):
    verified = UserRepository.verify_otp(db, data.identity, data.otp)
    if not verified:
        raise HTTPException(status_code=400, detail="Invalid OTP code")
    return APIResponse(
        status="success",
        message="Password reset successfully",
        data={},
    )
