from pydantic import BaseModel, Field
from typing import Optional, Any

class UserRegister(BaseModel):
    full_name: str
    mobile: str
    email: str
    password: str = Field(..., min_length=8)
    role: str = "ruralFarmer"
    state: Optional[str] = "Tamil Nadu"
    district: Optional[str] = "Coimbatore"
    village: Optional[str] = "Pollachi"

class UserLogin(BaseModel):
    email: str
    password: str

class UserLoginMobile(BaseModel):
    mobile: str
    full_name: Optional[str] = "Ramu Selvam"
    password: Optional[str] = None

class OTPRequest(BaseModel):
    mobile: str
    full_name: Optional[str] = "Ramu Selvam"

class OTPVerify(BaseModel):
    mobile: str
    otp: str
    full_name: Optional[str] = "Ramu Selvam"

class RefreshTokenRequest(BaseModel):
    refresh_token: str

class ForgotPasswordRequest(BaseModel):
    identity: str

class ResetPasswordRequest(BaseModel):
    identity: str
    otp: str
    new_password: str

class ChangePasswordRequest(BaseModel):
    old_password: str
    new_password: str

class ProfileUpdate(BaseModel):
    full_name: Optional[str] = None
    language: Optional[str] = None
    state: Optional[str] = None
    district: Optional[str] = None
    village: Optional[str] = None

class FirebaseLoginRequest(BaseModel):
    id_token: str
    mobile: str
    full_name: Optional[str] = "Ramu Selvam"
    device_info: Optional[str] = "Web Browser"

class FarmerProfileResponse(BaseModel):
    id: str
    firebase_uid: Optional[str] = None
    full_name: str
    mobile: str
    role: str = "farmer"
    status: str = "active"
    state: Optional[str] = "Tamil Nadu"
    district: Optional[str] = "Coimbatore"
    village: Optional[str] = "Pollachi"
    last_login: Optional[str] = None
    created_at: Optional[str] = None

class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    user_id: str
    role: str = "farmer"
    farmer_profile: Optional[FarmerProfileResponse] = None

class APIResponse(BaseModel):
    status: str = "success"
    message: str = "Operation completed successfully"
    data: Optional[Any] = None
