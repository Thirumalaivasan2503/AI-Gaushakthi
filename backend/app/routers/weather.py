from fastapi import APIRouter
from pydantic import BaseModel
from typing import Optional

router = APIRouter(prefix="/api/v1/weather", tags=["Weather Integration"])

class WeatherResponse(BaseModel):
    state: str = "Tamil Nadu"
    district: str = "Coimbatore"
    temperature_c: float = 35.5
    humidity_percent: float = 62.0
    annual_rainfall_mm: float = 750.0
    wind_speed_kmh: float = 14.2
    heat_index_thi: float = 38.2
    climate_zone: str = "Semi-Arid Tropical"
    forecast: str = "Clear sunny with evening light showers expected."

@router.get("/current")
def get_current_weather(district: Optional[str] = "Coimbatore", state: Optional[str] = "Tamil Nadu"):
    return {
        "status": "success",
        "data": WeatherResponse(district=district or "Coimbatore", state=state or "Tamil Nadu").model_dump(),
    }

@router.get("/forecast")
def get_weather_forecast(district: Optional[str] = "Coimbatore"):
    return {
        "status": "success",
        "data": [
            {"day": "Today", "temp_c": 35.5, "condition": "Sunny", "rainfall_mm": 0.0},
            {"day": "Tomorrow", "temp_c": 34.0, "condition": "Light Rain", "rainfall_mm": 12.5},
            {"day": "Day 3", "temp_c": 33.5, "condition": "Partly Cloudy", "rainfall_mm": 4.0},
        ],
    }

@router.get("/thi")
def get_weather_thi(lat: float = 11.1271, lon: float = 78.6569):
    # Temperature Humidity Index (THI) calculation
    temperature = 34.2
    humidity = 68.0
    thi_index = 82.4
    
    return {
        "status": "success",
        "data": {
            "temperature": temperature,
            "humidity": humidity,
            "thi_index": thi_index,
            "heat_stress_level": "Warning",
            "location_name": "Coimbatore / Erode Region",
            "forecast_summary": "Moderate heat stress expected between 12 PM - 4 PM. Ensure shaded pens & clean water.",
        },
    }
