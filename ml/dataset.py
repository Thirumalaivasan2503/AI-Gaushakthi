import random
import json

INDIGENOUS_BREEDS = [
    "Kangayam Cattle",
    "Gir Cow",
    "Sahiwal Cow",
    "Ongole Cattle",
    "Bargur Cattle",
    "Umblachery Cattle",
    "Pulikulam Cattle",
]

CLIMATE_ZONES = [
    "Semi-Arid Tropical",
    "Arid Desert Zone",
    "Humid Coastal",
    "Subtropical Plains",
]

SOIL_TYPES = [
    "Red Loamy Soil",
    "Black Cotton Soil",
    "Sandy Loam",
    "Clay Loam",
]

PRODUCTIVITY_GOALS = [
    "Milk Production",
    "Draft & Tillage",
    "Breeding & Genetics",
    "Dual Purpose",
    "Low Maintenance & Disease Immunity",
]

def generate_synthetic_agritech_dataset(num_samples=1000):
    """Generates a structured dataset for indigenous cattle breed recommendation model training."""
    dataset = []
    
    for i in range(num_samples):
        temp = round(random.uniform(22.0, 48.0), 1)
        rainfall = round(random.uniform(300.0, 1800.0), 1)
        humidity = round(random.uniform(40.0, 90.0), 1)
        farm_size = round(random.uniform(0.5, 25.0), 1)
        feed_budget = round(random.uniform(5000.0, 50000.0), 0)
        medical_budget = round(random.uniform(2000.0, 20000.0), 0)
        climate = random.choice(CLIMATE_ZONES)
        goal = random.choice(PRODUCTIVITY_GOALS)
        soil = random.choice(SOIL_TYPES)
        water_avail = random.choice(["Abundant", "Moderate", "Limited Rainfed"])

        # Target Label heuristic logic
        if goal == "Draft & Tillage" or (temp > 40 and rainfall < 600):
            target_breed = "Kangayam Cattle"
        elif goal == "Milk Production" and feed_budget > 25000 and temp < 38:
            target_breed = random.choice(["Sahiwal Cow", "Gir Cow"])
        elif temp > 42 and rainfall < 500 and soil == "Red Loamy Soil":
            target_breed = "Bargur Cattle"
        elif climate == "Humid Coastal" or goal == "Dual Purpose":
            target_breed = "Umblachery Cattle"
        elif goal == "Breeding & Genetics":
            target_breed = "Ongole Cattle"
        else:
            target_breed = random.choice(INDIGENOUS_BREEDS)

        sample = {
            "sample_id": f"sample_{i+1:04d}",
            "farm_size_acres": farm_size,
            "average_temp_c": temp,
            "annual_rainfall_mm": rainfall,
            "humidity_percent": humidity,
            "feed_budget_monthly": feed_budget,
            "medical_budget_monthly": medical_budget,
            "climate_zone": climate,
            "soil_type": soil,
            "water_availability": water_avail,
            "productivity_goal": goal,
            "livestock_count": random.randint(1, 15),
            "disease_history_count": random.randint(0, 3),
            "target_recommended_breed": target_breed,
        }
        dataset.append(sample)

    return dataset

if __name__ == "__main__":
    data = generate_synthetic_agritech_dataset(1200)
    with open("ml/agritech_dataset.json", "w") as f:
        json.dump(data, f, indent=2)
    print(f"Generated {len(data)} training samples in ml/agritech_dataset.json")
