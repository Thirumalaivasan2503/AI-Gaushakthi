import uuid
from sqlalchemy import Column, String, Boolean, DateTime, ForeignKey, Numeric, Integer, JSON, Text
from sqlalchemy.sql import func
from app.database.database import Base

class UserModel(Base):
    __tablename__ = "users"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    firebase_uid = Column(String(128), unique=True, nullable=True, index=True)
    full_name = Column(String(120), nullable=False)
    mobile = Column(String(20), unique=True, nullable=False)
    email = Column(String(120), unique=True, nullable=True)
    password_hash = Column(String(255), nullable=True)
    role = Column(String(30), default="farmer")
    language = Column(String(10), default="en")
    status = Column(String(20), default="active")
    device_info = Column(Text, nullable=True)
    last_login = Column(DateTime(timezone=True), nullable=True)
    is_active = Column(Boolean, default=True)
    is_deleted = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

# Alias User for auth repositories compatibility
User = UserModel

class FarmerProfileModel(Base):
    __tablename__ = "farmer_profiles"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False)
    state = Column(String(100), nullable=False)
    district = Column(String(100), nullable=False)
    village = Column(String(100), nullable=False)
    livestock_focus = Column(String(150), default="Indigenous Cattle (Cows/Bulls)")
    land_holding_acres = Column(Numeric(6, 2), default=0.0)
    available_budget_inr = Column(Numeric(10, 2), default=50000.0)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class VeterinaryProfileModel(Base):
    __tablename__ = "veterinary_profiles"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False)
    registration_number = Column(String(80), unique=True, nullable=False)
    specialization = Column(String(150), nullable=False)
    clinic_address = Column(Text, nullable=False)
    is_verified = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class AdminProfileModel(Base):
    __tablename__ = "admin_profiles"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False)
    department = Column(String(120), nullable=False)
    admin_level = Column(String(50), default="SystemAdmin")
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class RefreshTokenModel(Base):
    __tablename__ = "refresh_tokens"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    token = Column(Text, unique=True, nullable=False)
    expires_at = Column(DateTime(timezone=True), nullable=False)
    is_revoked = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class OTPVerificationModel(Base):
    __tablename__ = "otp_verifications"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    mobile = Column(String(20), nullable=False)
    otp_code = Column(String(10), nullable=False)
    is_used = Column(Boolean, default=False)
    expires_at = Column(DateTime(timezone=True), nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class AuditLogModel(Base):
    __tablename__ = "audit_logs"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String(36), ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    action = Column(String(100), nullable=False)
    details = Column(Text, nullable=True)
    ip_address = Column(String(45), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class LivestockModel(Base):
    __tablename__ = "livestock"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    farmer_profile_id = Column(String(36), ForeignKey("farmer_profiles.id", ondelete="CASCADE"), nullable=False)
    animal_tag_id = Column(String(80), nullable=False)
    name = Column(String(100), nullable=False)
    breed = Column(String(100), nullable=False)
    species = Column(String(50), default="Cattle")
    gender = Column(String(20), nullable=False)
    age_years = Column(Numeric(4, 1), default=3.0)
    weight_kg = Column(Numeric(6, 1), default=400.0)
    health_status = Column(String(50), default="healthy")

class MedicalRecordModel(Base):
    __tablename__ = "medical_records"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    livestock_id = Column(String(36), ForeignKey("livestock.id", ondelete="CASCADE"), nullable=False)
    animal_tag_id = Column(String(80), nullable=False)
    title = Column(String(150), nullable=False)
    vet_name = Column(String(120), nullable=False)
    due_date = Column(String(50), nullable=False)
    status = Column(String(50), default="Completed")
    report_file_name = Column(String(255), nullable=True)
    report_file_path = Column(Text, nullable=True)
    batch_no = Column(String(80), nullable=True)
    immunity_status = Column(String(150), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class RecommendationHistoryModel(Base):
    __tablename__ = "recommendation_history"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    recommended_breed = Column(String(100), nullable=False)
    confidence_score = Column(Numeric(5, 2), nullable=False)
    productivity_goal = Column(String(100), nullable=False)
    input_vector = Column(JSON)
    xai_rationale = Column(JSON)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
