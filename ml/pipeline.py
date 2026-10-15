import json
import numpy as np

CLIMATE_MAP = {"Semi-Arid Tropical": 0, "Arid Desert Zone": 1, "Humid Coastal": 2, "Subtropical Plains": 3}
SOIL_MAP = {"Red Loamy Soil": 0, "Black Cotton Soil": 1, "Sandy Loam": 2, "Clay Loam": 3}
WATER_MAP = {"Abundant": 0, "Moderate": 1, "Limited Rainfed": 2}
GOAL_MAP = {
    "Milk Production": 0,
    "Draft & Tillage": 1,
    "Breeding & Genetics": 2,
    "Dual Purpose": 3,
    "Low Maintenance & Disease Immunity": 4,
}

BREED_LABEL_MAP = {
    "Kangayam Cattle": 0,
    "Gir Cow": 1,
    "Sahiwal Cow": 2,
    "Ongole Cattle": 3,
    "Bargur Cattle": 4,
    "Umblachery Cattle": 5,
    "Pulikulam Cattle": 6,
}
INV_BREED_LABEL_MAP = {v: k for k, v in BREED_LABEL_MAP.items()}

def extract_feature_vector(sample: dict) -> list[float]:
    """Encodes a single raw sample dictionary into a numerical feature vector."""
    c_val = CLIMATE_MAP.get(sample.get("climate_zone", ""), 0)
    s_val = SOIL_MAP.get(sample.get("soil_type", ""), 0)
    w_val = WATER_MAP.get(sample.get("water_availability", ""), 0)
    g_val = GOAL_MAP.get(sample.get("productivity_goal", ""), 0)

    # Feature Engineering: Budget Ratio & Heat Index proxy
    feed_budget = float(sample.get("feed_budget_monthly", 15000))
    med_budget = float(sample.get("medical_budget_monthly", 5000))
    budget_ratio = feed_budget / (med_budget + 1.0)
    temp = float(sample.get("average_temp_c", 32.0))
    humidity = float(sample.get("humidity_percent", 60.0))
    thi_proxy = temp + (0.55 * (humidity / 100.0) * (temp - 14.5))

    vector = [
        float(sample.get("farm_size_acres", 5.0)),
        temp,
        float(sample.get("annual_rainfall_mm", 750.0)),
        humidity,
        feed_budget,
        med_budget,
        float(c_val),
        float(s_val),
        float(w_val),
        float(g_val),
        float(sample.get("livestock_count", 3)),
        float(sample.get("disease_history_count", 0)),
        budget_ratio,
        thi_proxy,
    ]
    return vector

FEATURE_NAMES = [
    "farm_size_acres",
    "average_temp_c",
    "annual_rainfall_mm",
    "humidity_percent",
    "feed_budget_monthly",
    "medical_budget_monthly",
    "climate_zone_code",
    "soil_type_code",
    "water_availability_code",
    "productivity_goal_code",
    "livestock_count",
    "disease_history_count",
    "budget_ratio",
    "thi_heat_index",
]

def load_and_preprocess_dataset(filepath="ml/agritech_dataset.json"):
    with open(filepath, "r") as f:
        samples = json.load(f)

    X = []
    y = []
    for s in samples:
        X.append(extract_feature_vector(s))
        y.append(BREED_LABEL_MAP.get(s["target_recommended_breed"], 0))

    return np.array(X), np.array(y)
