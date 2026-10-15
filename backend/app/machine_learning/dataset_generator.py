import random
import json
import os

INDIGENOUS_BREEDS = [
    "Kangayam Cattle",
    "Gir Cow",
    "Sahiwal Cow",
    "Ongole Cattle",
    "Bargur Cattle",
    "Tellicherry / Malabari Goat",
]

STATES = ["Tamil Nadu", "Gujarat", "Punjab", "Andhra Pradesh", "Karnataka", "Kerala", "Rajasthan"]
CLIMATE_ZONES = ["Semi-Arid Tropical", "Arid Desert Zone", "Humid Coastal", "Subtropical Plains"]
SOIL_TYPES = ["Red Loamy Soil", "Black Cotton Soil", "Sandy Loam", "Clay Loam"]
WATER_SOURCES = ["Abundant Borewell", "Moderate Open Well", "Limited Rainfed Pond"]
PRODUCTIVITY_GOALS = ["Milk Production", "Draft & Tillage", "Breeding & Genetics", "Meat Production", "Low Maintenance & Disease Immunity"]
FEED_TYPES = ["Co-4 Napier Grass & Stover", "Sorghum & Concentrate Cake", "Wild Pasture Grazing", "Tree Leaves & Legumes"]

def generate_26_feature_dataset(num_samples=1500):
    """Generates structured 26-feature dataset for indigenous livestock breed selection."""
    dataset = []

    for i in range(num_samples):
        farmer_age = random.randint(22, 68)
        state = random.choice(STATES)
        district = f"{state} District {random.randint(1, 5)}"
        climate = random.choice(CLIMATE_ZONES)
        temp = round(random.uniform(22.0, 48.0), 1)
        humidity = round(random.uniform(35.0, 92.0), 1)
        rainfall = round(random.uniform(300.0, 1800.0), 1)
        water_avail = random.choice(WATER_SOURCES)
        soil = random.choice(SOIL_TYPES)
        farm_size = round(random.uniform(0.5, 25.0), 1)
        avail_budget = round(random.uniform(25000.0, 250000.0), 0)
        feed_budget = round(random.uniform(5000.0, 45000.0), 0)
        med_budget = round(random.uniform(2000.0, 20000.0), 0)
        livestock_count = random.randint(1, 20)
        disease_history = random.randint(0, 4)
        vaccination_status = random.choice(["Up-to-Date", "Partially Vaccinated", "Not Vaccinated"])
        animal_health = random.choice(["Healthy", "Recovering", "Under Observation"])
        feed_type = random.choice(FEED_TYPES)
        feed_cost = round(feed_budget * random.uniform(0.7, 0.95), 0)
        prod_goal = random.choice(PRODUCTIVITY_GOALS)
        milk_req_liters = round(random.uniform(5.0, 25.0), 1)
        breeding_goal = random.choice(["Purebred Preservation", "High Yield Cross", "Draft Sire"])
        organic_pref = random.choice([True, False])
        maint_pref = random.choice(["Low Maintenance", "Moderate Supervision", "Intensive Dairy Shed"])
        sustain_goal = random.choice(["Zero Carbon Footprint", "High Income ROI", "Drought Resilience"])

        # Target Label Heuristics
        if prod_goal == "Draft & Tillage" or (temp > 40 and rainfall < 600):
            target = "Kangayam Cattle"
        elif prod_goal == "Milk Production" and feed_budget > 25000 and temp < 38:
            target = random.choice(["Sahiwal Cow", "Gir Cow"])
        elif temp > 42 and rainfall < 500 and soil == "Red Loamy Soil":
            target = "Bargur Cattle"
        elif prod_goal == "Meat Production" or farm_size < 2.0:
            target = "Tellicherry / Malabari Goat"
        elif climate == "Humid Coastal" or breeding_goal == "Draft Sire":
            target = "Ongole Cattle"
        else:
            target = random.choice(INDIGENOUS_BREEDS)

        sample = {
            "sample_id": f"sample_{i+1:04d}",
            "farmer_age": farmer_age,
            "state": state,
            "district": district,
            "climate_zone": climate,
            "average_temp_c": temp,
            "humidity_percent": humidity,
            "annual_rainfall_mm": rainfall,
            "water_availability": water_avail,
            "soil_type": soil,
            "farm_size_acres": farm_size,
            "available_budget_inr": avail_budget,
            "feed_budget_monthly_inr": feed_budget,
            "medical_budget_monthly_inr": med_budget,
            "livestock_count": livestock_count,
            "disease_history_count": disease_history,
            "vaccination_status": vaccination_status,
            "animal_health_status": animal_health,
            "feed_type": feed_type,
            "feed_cost_monthly_inr": feed_cost,
            "productivity_goal": prod_goal,
            "milk_requirement_liters": milk_req_liters,
            "breeding_goal": breeding_goal,
            "organic_farming_preference": organic_pref,
            "maintenance_preference": maint_pref,
            "sustainability_goal": sustain_goal,
            "target_recommended_breed": target,
        }
        dataset.append(sample)

    return dataset

if __name__ == "__main__":
    out_dir = os.path.dirname(os.path.abspath(__file__))
    os.makedirs(out_dir, exist_ok=True)
    data = generate_26_feature_dataset(1500)
    with open(os.path.join(out_dir, "agritech_26_features_dataset.json"), "w") as f:
        json.dump(data, f, indent=2)
    print(f"Generated {len(data)} samples in agritech_26_features_dataset.json")
