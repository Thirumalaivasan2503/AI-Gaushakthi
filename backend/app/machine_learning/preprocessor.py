import numpy as np

# Encoding Maps
CLIMATE_MAP = {"Semi-Arid Tropical": 0, "Arid Desert Zone": 1, "Humid Coastal": 2, "Subtropical Plains": 3}
SOIL_MAP = {"Red Loamy Soil": 0, "Black Cotton Soil": 1, "Sandy Loam": 2, "Clay Loam": 3}
WATER_MAP = {"Abundant Borewell": 0, "Moderate Open Well": 1, "Limited Rainfed Pond": 2}
VACC_MAP = {"Up-to-Date": 0, "Partially Vaccinated": 1, "Not Vaccinated": 2}
GOAL_MAP = {
    "Milk Production": 0,
    "Draft & Tillage": 1,
    "Breeding & Genetics": 2,
    "Meat Production": 3,
    "Low Maintenance & Disease Immunity": 4,
}

TARGET_BREED_MAP = {
    "Kangayam Cattle": 0,
    "Gir Cow": 1,
    "Sahiwal Cow": 2,
    "Ongole Cattle": 3,
    "Bargur Cattle": 4,
    "Tellicherry / Malabari Goat": 5,
}
INV_TARGET_BREED_MAP = {v: k for k, v in TARGET_BREED_MAP.items()}

FEATURE_NAMES = [
    "farmer_age",
    "climate_zone_code",
    "average_temp_c",
    "humidity_percent",
    "annual_rainfall_mm",
    "water_availability_code",
    "soil_type_code",
    "farm_size_acres",
    "available_budget_inr",
    "feed_budget_monthly_inr",
    "medical_budget_monthly_inr",
    "livestock_count",
    "disease_history_count",
    "vaccination_status_code",
    "productivity_goal_code",
    "milk_requirement_liters",
    "organic_pref_flag",
    "budget_ratio",
    "thi_heat_index",
]

def preprocess_single_request(data: dict) -> list[float]:
    """Encodes a 26-feature prediction request into a normalized numerical feature vector."""
    c_code = CLIMATE_MAP.get(data.get("climate_zone", "Semi-Arid Tropical"), 0)
    s_code = SOIL_MAP.get(data.get("soil_type", "Red Loamy Soil"), 0)
    w_code = WATER_MAP.get(data.get("water_availability", "Abundant Borewell"), 0)
    v_code = VACC_MAP.get(data.get("vaccination_status", "Up-to-Date"), 0)
    g_code = GOAL_MAP.get(data.get("productivity_goal", "Milk Production"), 0)

    feed_b = float(data.get("feed_budget_monthly_inr", 18000.0))
    med_b = float(data.get("medical_budget_monthly_inr", 5000.0))
    budget_ratio = feed_b / (med_b + 1.0)
    
    temp = float(data.get("average_temp_c", 34.0))
    humidity = float(data.get("humidity_percent", 65.0))
    thi_index = temp + (0.55 * (humidity / 100.0) * (temp - 14.5))

    vector = [
        float(data.get("farmer_age", 42)),
        float(c_code),
        temp,
        humidity,
        float(data.get("annual_rainfall_mm", 750.0)),
        float(w_code),
        float(s_code),
        float(data.get("farm_size_acres", 4.5)),
        float(data.get("available_budget_inr", 85000.0)),
        feed_b,
        med_b,
        float(data.get("livestock_count", 4)),
        float(data.get("disease_history_count", 0)),
        float(v_code),
        float(g_code),
        float(data.get("milk_requirement_liters", 12.0)),
        1.0 if data.get("organic_farming_preference", True) else 0.0,
        budget_ratio,
        thi_index,
    ]
    return vector
