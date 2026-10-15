from datetime import datetime, timedelta, timezone
from sqlalchemy.orm import Session
from app.models.models import User, FarmerProfileModel, VeterinaryProfileModel, AdminProfileModel, OTPVerificationModel, RefreshTokenModel, AuditLogModel
from app.core.security import get_password_hash

class UserRepository:
    @staticmethod
    def get_by_email(db: Session, email: str) -> User | None:
        return db.query(User).filter(User.email == email).first()

    @staticmethod
    def get_by_firebase_uid(db: Session, firebase_uid: str) -> User | None:
        return db.query(User).filter(User.firebase_uid == firebase_uid).first()

    @staticmethod
    def get_by_mobile(db: Session, mobile: str) -> User | None:
        return db.query(User).filter(User.mobile == mobile).first()

    @staticmethod
    def get_by_id(db: Session, user_id: str) -> User | None:
        return db.query(User).filter(User.id == user_id).first()

    @staticmethod
    def auto_register_or_get_farmer(
        db: Session,
        mobile: str,
        firebase_uid: str | None = None,
        full_name: str | None = None,
        device_info: str | None = None,
    ) -> User:
        """
        Retrieves existing farmer or automatically registers a new Farmer account.
        All users in this application are Farmers.
        """
        user = None
        if firebase_uid:
            user = UserRepository.get_by_firebase_uid(db, firebase_uid)
        if not user:
            user = UserRepository.get_by_mobile(db, mobile)

        now = datetime.now(timezone.utc)

        if user:
            # Update existing farmer record
            if firebase_uid and not user.firebase_uid:
                user.firebase_uid = firebase_uid
            if full_name and full_name != "Ramu Selvam" and user.full_name != full_name:
                user.full_name = full_name
            user.last_login = now
            user.status = "active"
            if device_info:
                user.device_info = device_info
            db.commit()
            db.refresh(user)
            UserRepository.log_audit(db, user.id, "FARMER_LOGIN_OTP", f"Device: {device_info or 'Unknown'}")
            return user

        # Auto-create new Farmer account
        clean_phone = mobile.replace(" ", "").replace("-", "").replace("+", "")
        placeholder_email = f"farmer_{clean_phone[-10:] if len(clean_phone) >= 10 else clean_phone}@gaushakthi.org"
        pwd_hash = get_password_hash("FarmerDefaultOTP2026!")

        user = User(
            firebase_uid=firebase_uid,
            full_name=full_name or "Ramu Selvam",
            mobile=mobile,
            email=placeholder_email,
            password_hash=pwd_hash,
            role="farmer",
            status="active",
            device_info=device_info,
            last_login=now,
            is_active=True,
        )
        db.add(user)
        db.commit()
        db.refresh(user)

        # Create linked Farmer profile
        farmer_profile = FarmerProfileModel(
            user_id=user.id,
            state="Tamil Nadu",
            district="Coimbatore",
            village="Pollachi",
            livestock_focus="Indigenous Cattle (Cows/Bulls)",
            available_budget_inr=50000.0,
        )
        db.add(farmer_profile)
        db.commit()
        db.refresh(user)

        UserRepository.log_audit(db, user.id, "FARMER_AUTO_REGISTER_OTP", f"Firebase UID: {firebase_uid}")
        return user

    @staticmethod
    def create_user(db: Session, user_data: dict) -> User:
        hashed_pwd = get_password_hash(user_data["password"])
        user = User(
            full_name=user_data["full_name"],
            mobile=user_data["mobile"],
            email=user_data["email"],
            password_hash=hashed_pwd,
            role=user_data.get("role", "ruralFarmer"),
        )
        db.add(user)
        db.commit()
        db.refresh(user)

        # Profile creation based on role
        if user.role in ["ruralFarmer", "urbanFarmer", "farmer"]:
            farmer_profile = FarmerProfileModel(
                user_id=user.id,
                state=user_data.get("state", "Tamil Nadu"),
                district=user_data.get("district", "Coimbatore"),
                village=user_data.get("village", "Pollachi"),
            )
            db.add(farmer_profile)
        elif user.role == "veterinaryExpert":
            vet_profile = VeterinaryProfileModel(
                user_id=user.id,
                registration_number=f"VET-{user.id[:8]}",
                specialization="Breeding & Genetics Specialist",
                clinic_address="District Veterinary Center",
            )
            db.add(vet_profile)
        elif user.role == "administrator":
            admin_profile = AdminProfileModel(
                user_id=user.id,
                department="State Animal Husbandry Board",
                admin_level="SuperAdmin",
            )
            db.add(admin_profile)

        db.commit()
        db.refresh(user)
        return user

    @staticmethod
    def save_otp(db: Session, mobile: str, otp_code: str = "123456") -> OTPVerificationModel:
        expires = datetime.now(timezone.utc) + timedelta(minutes=10)
        otp_entry = OTPVerificationModel(
            mobile=mobile,
            otp_code=otp_code,
            expires_at=expires,
        )
        db.add(otp_entry)
        db.commit()
        db.refresh(otp_entry)
        return otp_entry

    @staticmethod
    def verify_otp(db: Session, mobile: str, otp_code: str) -> bool:
        # Accepts '123456' for testing or valid active OTP
        if otp_code == "123456":
            return True
        otp_entry = (
            db.query(OTPVerificationModel)
            .filter(
                OTPVerificationModel.mobile == mobile,
                OTPVerificationModel.otp_code == otp_code,
                OTPVerificationModel.is_used == False,
            )
            .first()
        )
        if otp_entry:
            otp_entry.is_used = True
            db.commit()
            return True
        return False

    @staticmethod
    def log_audit(db: Session, user_id: str | None, action: str, details: str = ""):
        log = AuditLogModel(user_id=user_id, action=action, details=details)
        db.add(log)
        db.commit()
