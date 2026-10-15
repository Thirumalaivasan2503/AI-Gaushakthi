import os
import json
import joblib
import pandas as pd
import numpy as np
from typing import Dict, Any, List
from app.services.breed_master_service import BreedMasterService
from app.services.feed_master_service import FeedMasterService
from app.services.disease_master_service import DiseaseMasterService
from app.services.vaccination_master_service import VaccinationMasterService
from app.services.climate_master_service import ClimateMasterService
from app.services.economics_master_service import EconomicsMasterService

BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

MODEL_PATH = os.path.join(BASE_DIR, "models", "random_forest_model.joblib")
PREPROCESSOR_PATH = os.path.join(BASE_DIR, "models", "preprocessor.joblib")
METRICS_PATH = os.path.join(BASE_DIR, "models", "model_metrics.json")


class DatasetPredictionService:
    _rf_model = None
    _preprocessor = None
    _metrics = None

    @classmethod
    def load_artifacts(cls):
        """
        Loads random_forest_model.joblib and preprocessor.joblib once during FastAPI startup.
        """
        if not os.path.exists(MODEL_PATH) or not os.path.exists(PREPROCESSOR_PATH):
            from app.machine_learning.train_rf_model import train_and_evaluate_rf_model
            train_and_evaluate_rf_model()

        cls._rf_model = joblib.load(MODEL_PATH)
        cls._preprocessor = joblib.load(PREPROCESSOR_PATH)
        if os.path.exists(METRICS_PATH):
            with open(METRICS_PATH, "r") as f:
                cls._metrics = json.load(f)

    @classmethod
    def predict(cls, req_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Accepts farmer inputs, predicts breed using Random Forest model,
        and automatically combines all 6 knowledge base datasets into a single AI Recommendation Report.
        """
        if cls._rf_model is None or cls._preprocessor is None:
            cls.load_artifacts()

        label_encoders = cls._preprocessor["label_encoders"]
        target_encoder = cls._preprocessor["target_encoder"]
        scaler = cls._preprocessor.get("scaler")
        feature_cols = cls._preprocessor["feature_cols"]
        categorical_cols = cls._preprocessor["categorical_cols"]
        numerical_cols = cls._preprocessor["numerical_cols"]

        # Map all farmer inputs safely
        farmer_name = str(req_data.get("farmer_name") or req_data.get("Farmer Name") or "Farmer")
        species = str(req_data.get("species") or req_data.get("Species") or "Cattle")

        row = {
            "State": str(req_data.get("state") or req_data.get("State") or "Tamil Nadu"),
            "District": str(req_data.get("district") or req_data.get("District") or "Erode"),
            "Temperature_C": float(req_data.get("max_temperature_c") or req_data.get("average_temperature") or req_data.get("Average Temperature") or 34.5),
            "Humidity_%": float(req_data.get("humidity_percent") or req_data.get("humidity") or req_data.get("Humidity") or 65.0),
            "Rainfall_mm": float(req_data.get("annual_rainfall_mm") or req_data.get("rainfall") or req_data.get("Rainfall") or 720.0),
            "Soil_Type": str(req_data.get("soil_type") or req_data.get("Soil Type") or "Red"),
            "Water_Availability": str(req_data.get("water_availability") or req_data.get("Water Availability") or "Medium"),
            "Farm_Size_Acres": float(req_data.get("land_holding_acres") or req_data.get("farm_size") or req_data.get("Farm Size") or 4.5),
            "Feed_Budget_INR": float(req_data.get("feed_budget_monthly") or req_data.get("farming_budget") or req_data.get("Farming Budget") or 18000.0),
            "Medical_Budget_INR": float(req_data.get("medical_budget_monthly") or req_data.get("Medical_Budget_INR") or 5000.0),
            "Disease_History": str(req_data.get("disease_history") or req_data.get("Disease History") or "None"),
            "Vaccination_Status": str(req_data.get("vaccination_status") or req_data.get("Vaccination Status") or "Yes"),
            "Livestock_Purpose": str(req_data.get("primary_purpose") or req_data.get("breed_purpose") or req_data.get("Breed Purpose") or "Milk"),
            "Organic_Farming": str(req_data.get("organic_farming") or req_data.get("Organic Farming") or "Yes"),
            "Climate_Zone": str(req_data.get("climate_zone") or req_data.get("climate_type") or req_data.get("Climate Type") or "Semi-Arid"),
            "Productivity_Goal": str(req_data.get("productivity_goal") or req_data.get("Productivity Goal") or "High Milk"),
        }

        # Encode categorical features
        encoded_row = {}
        for col in feature_cols:
            val = row[col]
            if col in label_encoders:
                le = label_encoders[col]
                if val in le.classes_:
                    encoded_row[col] = le.transform([val])[0]
                else:
                    encoded_row[col] = 0
            else:
                encoded_row[col] = float(val)

        X_df = pd.DataFrame([encoded_row])[feature_cols]

        if scaler and numerical_cols:
            X_df[numerical_cols] = scaler.transform(X_df[numerical_cols])

        # RF Predict Proba
        probabilities = cls._rf_model.predict_proba(X_df)[0]
        classes = target_encoder.classes_

        # Rank top predictions
        ranked_indices = np.argsort(probabilities)[::-1]
        top_class_idx = ranked_indices[0]
        primary_breed = classes[top_class_idx]
        confidence_pct = round(float(probabilities[top_class_idx]) * 100, 1)

        # Build Top 3 Recommended Breeds list
        top_3 = []
        for idx in ranked_indices[:3]:
            alt_breed = classes[idx]
            alt_conf = round(float(probabilities[idx]) * 100, 1)
            top_3.append({
                "breed_name": alt_breed,
                "confidence_score": alt_conf,
            })

        # --- INTEGRATE ALL 6 MASTER KNOWLEDGE BASE DATASETS ---
        # 1. breed_master.csv
        breed_details = BreedMasterService.get_breed_by_name(primary_breed) or {}
        # 2. feed_master.csv
        feed_details = FeedMasterService.get_feed_by_breed_name(primary_breed) or {}
        # 3. disease_master.csv
        disease_details = DiseaseMasterService.get_disease_by_name(row["Disease_History"]) or {}
        # 4. vaccination_master.csv
        target_disease_name = disease_details.get("Disease_Name", "Foot and Mouth Disease") if disease_details else "Foot and Mouth Disease"
        vaccination_schedule = VaccinationMasterService.get_vaccinations_by_disease(target_disease_name)
        # 5. climate_master.csv
        climate_details = ClimateMasterService.get_climate_by_state_and_district(row["State"], row["District"]) or {}
        # 6. economics_master.csv
        economics_details = EconomicsMasterService.get_economics_by_breed_name(primary_breed) or {}

        # Derived Analytics Scores
        sustainability_score = float(economics_details.get("Sustainability_Score") or climate_details.get("Sustainability_Score") or breed_details.get("Sustainability_Score") or 96.0)
        disease_resistance_score = 95.0 if "high" in str(breed_details.get("Disease_Resistance", "high")).lower() else 85.0
        climate_suitability_score = 94.0 if "low" in str(climate_details.get("Heat_Index", "low")).lower() else 88.0
        cost_efficiency_score = round(min(99.0, (1.0 - (float(feed_details.get("Daily_Feed_Cost_INR", 120)) / 350.0)) * 100), 1)
        productivity_pred = f"{breed_details.get('Milk_Yield_Liters_Day', 8.0)} L/Day Milk Yield ({row['Productivity_Goal']})"

        # Summary text
        summary = (
            f"Based on {row['District']}, {row['State']} climate ({climate_details.get('Climate_Type', 'Semi-Arid')}), "
            f"monthly budget ₹{row['Feed_Budget_INR']}, and {row['Livestock_Purpose']} purpose, {primary_breed} is recommended "
            f"with {confidence_pct}% AI confidence score and an estimated annual net profit of ₹{economics_details.get('Net_Profit_INR', 125000)}."
        )

        return {
            "recommended_breed": primary_breed,
            "confidence_score": confidence_pct,
            "top_3_recommended_breeds": top_3,
            "sustainability_score": sustainability_score,
            "disease_resistance_score": disease_resistance_score,
            "climate_suitability_score": climate_suitability_score,
            "cost_efficiency_score": cost_efficiency_score,
            "productivity_prediction": productivity_pred,
            "ai_confidence_score": confidence_pct,
            "ai_recommendation_summary": summary,
            "farmer_name": farmer_name,
            "species": species,
            # Integrated Knowledge Base Datasets
            "breed_details": breed_details,
            "feed_details": feed_details,
            "disease_details": disease_details,
            "vaccination_schedule": vaccination_schedule,
            "climate_details": climate_details,
            "economics_details": economics_details,
            # Top-level required financial & agronomic summary fields
            "Estimated_Treatment_Cost_INR": disease_details.get("Estimated_Treatment_Cost_INR", 1500),
            "Daily_Feed_Cost_INR": feed_details.get("Daily_Feed_Cost_INR", economics_details.get("Daily_Feed_Cost_INR", 120)),
            "Annual_Maintenance_Cost_INR": economics_details.get("Monthly_Maintenance_Cost_INR", 3500) * 12 if isinstance(economics_details.get("Monthly_Maintenance_Cost_INR"), (int, float)) else 42000,
            "Expected_Annual_Income_INR": economics_details.get("Expected_Annual_Income_INR", 210000),
            "Net_Profit_INR": economics_details.get("Net_Profit_INR", 125000),
            "ROI": economics_details.get("ROI_Percentage", 240.0),
            "ROI_Percentage": economics_details.get("ROI_Percentage", 240.0),
        }

    @classmethod
    def get_model_metrics(cls) -> Dict[str, Any]:
        if cls._metrics is None:
            if os.path.exists(METRICS_PATH):
                with open(METRICS_PATH, "r") as f:
                    cls._metrics = json.load(f)
            else:
                cls.load_artifacts()
        return cls._metrics or {}
