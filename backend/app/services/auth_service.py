from sqlalchemy.orm import Session
from fastapi import HTTPException, status
from app.repositories.user_repository import UserRepository
from app.core.security import verify_password, create_access_token, create_refresh_token, decode_token
from app.services.firebase_service import FirebaseService
from app.schemas.schemas import UserRegister, TokenResponse, FarmerProfileResponse

class AuthService:
    @staticmethod
    def login_with_firebase_token(
        db: Session,
        id_token: str,
        mobile: str,
        full_name: str | None = None,
        device_info: str | None = None,
    ) -> TokenResponse:
        """
        Verifies Firebase ID token with Firebase Admin SDK, auto-registers or fetches farmer,
        and returns signed JWT Access & Refresh tokens + Farmer profile.
        """
        try:
            claims = FirebaseService.verify_id_token(id_token)
            firebase_uid = claims.get("uid")
        except Exception as err:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail=f"Firebase OTP Token Verification Failed: {str(err)}",
            )

        # Retrieve or auto-register Farmer
        user = UserRepository.auto_register_or_get_farmer(
            db,
            mobile=mobile,
            firebase_uid=firebase_uid,
            full_name=full_name,
            device_info=device_info,
        )

        access_token = create_access_token({"sub": user.id, "role": "farmer", "mobile": user.mobile})
        refresh_token = create_refresh_token({"sub": user.id, "role": "farmer", "mobile": user.mobile})

        profile_resp = FarmerProfileResponse(
            id=user.id,
            firebase_uid=user.firebase_uid,
            full_name=user.full_name,
            mobile=user.mobile,
            role="farmer",
            status=user.status or "active",
            state="Tamil Nadu",
            district="Coimbatore",
            village="Pollachi",
            last_login=user.last_login.isoformat() if user.last_login else None,
            created_at=user.created_at.isoformat() if user.created_at else None,
        )

        return TokenResponse(
            access_token=access_token,
            refresh_token=refresh_token,
            user_id=user.id,
            role="farmer",
            farmer_profile=profile_resp,
        )
    @staticmethod
    def register_user(db: Session, data: UserRegister) -> TokenResponse:
        existing_email = UserRepository.get_by_email(db, data.email)
        if existing_email:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="User with this email address already exists",
            )
        
        user = UserRepository.create_user(db, data.model_dump())
        access_token = create_access_token({"sub": user.id, "role": user.role})
        refresh_token = create_refresh_token({"sub": user.id, "role": user.role})

        UserRepository.log_audit(db, user.id, "USER_REGISTER", f"Registered role {user.role}")

        return TokenResponse(
            access_token=access_token,
            refresh_token=refresh_token,
            user_id=user.id,
            role=user.role,
        )

    @staticmethod
    def login_email(db: Session, email: str, password: str) -> TokenResponse:
        user = UserRepository.get_by_email(db, email)
        if not user or not verify_password(password, user.password_hash):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid email or password",
            )
        
        access_token = create_access_token({"sub": user.id, "role": user.role})
        refresh_token = create_refresh_token({"sub": user.id, "role": user.role})

        UserRepository.log_audit(db, user.id, "USER_LOGIN_EMAIL")

        return TokenResponse(
            access_token=access_token,
            refresh_token=refresh_token,
            user_id=user.id,
            role=user.role,
        )

    @staticmethod
    def login_mobile(db: Session, mobile: str, password: str | None = None, full_name: str | None = None) -> TokenResponse:
        user = UserRepository.get_by_mobile(db, mobile)
        if not user:
            # Generate user record for new mobile registration
            reg_data = UserRegister(
                full_name=full_name or "Ramu Selvam",
                mobile=mobile,
                email=f"user_{mobile[-4:] if len(mobile) >= 4 else '1001'}@gaushakthi.org",
                password=password or "Password123",
                role="ruralFarmer",
            )
            return AuthService.register_user(db, reg_data)

        if password and not verify_password(password, user.password_hash):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid password",
            )

        access_token = create_access_token({"sub": user.id, "role": user.role})
        refresh_token = create_refresh_token({"sub": user.id, "role": user.role})

        UserRepository.log_audit(db, user.id, "USER_LOGIN_MOBILE")

        return TokenResponse(
            access_token=access_token,
            refresh_token=refresh_token,
            user_id=user.id,
            role=user.role,
        )

    @staticmethod
    def verify_otp_and_login(db: Session, mobile: str, otp: str, full_name: str | None = None) -> TokenResponse:
        verified = UserRepository.verify_otp(db, mobile, otp)
        if not verified:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Invalid or expired OTP code",
            )
        return AuthService.login_mobile(db, mobile, full_name=full_name)

    @staticmethod
    def refresh_access_token(db: Session, refresh_token: str) -> TokenResponse:
        payload = decode_token(refresh_token)
        user_id = payload.get("sub")
        if not user_id or payload.get("type") != "refresh":
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid refresh token",
            )
        
        user = UserRepository.get_by_id(db, user_id)
        if not user:
            raise HTTPException(status_code=404, detail="User not found")

        new_access = create_access_token({"sub": user.id, "role": user.role})
        new_refresh = create_refresh_token({"sub": user.id, "role": user.role})

        return TokenResponse(
            access_token=new_access,
            refresh_token=new_refresh,
            user_id=user.id,
            role=user.role,
        )
