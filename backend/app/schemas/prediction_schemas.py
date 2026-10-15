from pydantic import BaseModel, Field
from typing import Optional, List, Dict, Any

class Prediction26FeatureRequest(BaseModel):
    farmer_age: Optional[int] = Field(default=42, ge=18, le=100)
    state: Optional[str] = "Tamil Nadu"
    district: Optional[str] = "Coimbatore"
    climate_zone: Optional[str] = "Semi-Arid Tropical"
    average_temp_c: Optional[float] = Field(default=35.0, ge=0.0, le=60.0)
    humidity_percent: Optional[float] = Field(default=65.0, ge=0.0, le=100.0)
    annual_rainfall_mm: Optional[float] = Field(default=750.0, ge=0.0, le=5000.0)
    water_availability: Optional[str] = "Abundant Borewell"
    soil_type: Optional[str] = "Red Loamy Soil"
    farm_size_acres: Optional[float] = Field(default=4.5, ge=0.1, le=500.0)
    available_budget_inr: Optional[float] = Field(default=85000.0, ge=0.0)
    feed_budget_monthly_inr: Optional[float] = Field(default=18000.0, ge=0.0)
    medical_budget_monthly_inr: Optional[float] = Field(default=5000.0, ge=0.0)
    livestock_count: Optional[int] = Field(default=4, ge=0)
    disease_history_count: Optional[int] = Field(default=0, ge=0)
    vaccination_status: Optional[str] = "Up-to-Date"
    animal_health_status: Optional[str] = "Healthy"
    feed_type: Optional[str] = "Co-4 Napier Grass & Stover"
    feed_cost_monthly_inr: Optional[float] = Field(default=15000.0, ge=0.0)
    productivity_goal: Optional[str] = "Milk Production"
    milk_requirement_liters: Optional[float] = Field(default=12.0, ge=0.0)
    breeding_goal: Optional[str] = "Purebred Preservation"
    organic_farming_preference: Optional[bool] = True
    maintenance_preference: Optional[str] = "Low Maintenance"
    sustainability_goal: Optional[str] = "High Income ROI"

class Prediction26Response(BaseModel):
    status: str = "success"
    message: str = "AI recommendation generated"
    data: Dict[str, Any]
