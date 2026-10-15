import os
import sys

# Ensure backend root is on sys.path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from app.database.database import SessionLocal, Base, engine
from app.models.models import (
    UserModel, FarmerProfileModel, LivestockModel, RecommendationHistoryModel
)
from app.core.security import get_password_hash

def seed_production_database():
    """Populates realistic agronomic sample data for demonstration & testing."""
    Base.metadata.create_all(bind=engine)
    db = SessionLocal()

    try:
        # 1. Seed Demo Farmer
        user = db.query(UserModel).filter(UserModel.mobile == "+919566405680").first()
        if not user:
            user = UserModel(
                full_name="Thiru",
                mobile="+919566405680",
                email="thiru@agritech.in",
                password_hash=get_password_hash("FarmerSecret123!"),
                role="farmer",
                language="en",
            )
            db.add(user)
            db.commit()
            db.refresh(user)

        # 2. Seed Farmer Profile
        profile = db.query(FarmerProfileModel).filter(FarmerProfileModel.user_id == user.id).first()
        if not profile:
            profile = FarmerProfileModel(
                user_id=user.id,
                state="Tamil Nadu",
                district="Coimbatore",
                village="Pollachi / Kottur",
                livestock_focus="Cattle & Goats",
                land_holding_acres=4.5,
                available_budget_inr=75000.0,
            )
            db.add(profile)
            db.commit()
            db.refresh(profile)

        # 3. Seed Registered Livestock
        livestock_count = db.query(LivestockModel).filter(LivestockModel.farmer_profile_id == profile.id).count()
        if livestock_count == 0:
            animals = [
                LivestockModel(
                    farmer_profile_id=profile.id,
                    animal_tag_id="KANG-TN-8801",
                    name="Valli",
                    breed="Kangayam Cattle",
                    species="Cattle",
                    gender="Female",
                    age_years=3.5,
                    weight_kg=420.0,
                    health_status="healthy",
                ),
                LivestockModel(
                    farmer_profile_id=profile.id,
                    animal_tag_id="SAHI-PB-9902",
                    name="Lakshmi",
                    breed="Sahiwal Cow",
                    species="Cattle",
                    gender="Female",
                    age_years=4.0,
                    weight_kg=480.0,
                    health_status="healthy",
                ),
            ]
            db.add_all(animals)
            db.commit()

        # 4. Seed Recommendation History
        rec_count = db.query(RecommendationHistoryModel).filter(RecommendationHistoryModel.user_id == user.id).count()
        if rec_count == 0:
            rec = RecommendationHistoryModel(
                user_id=user.id,
                recommended_breed="Kangayam Cattle",
                confidence_score=96.8,
                productivity_goal="Draft & Tillage",
                input_vector={"state": "Tamil Nadu", "temperature": 35.5, "budget": 75000},
                xai_rationale={
                    "climate_suitability": "Exceptional resistance up to 48°C",
                    "disease_immunity": "High genetic resistance to FMD and endemic parasites",
                    "annual_roi_inr": 35000,
                },
            )
            db.add(rec)
            db.commit()

        print("Successfully seeded production database with realistic agronomic sample data!")
    except Exception as e:
        print(f"Error seeding database: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    seed_production_database()
