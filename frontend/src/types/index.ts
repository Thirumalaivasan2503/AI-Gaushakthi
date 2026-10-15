export type UserRole = 'farmer' | 'veterinary_expert' | 'administrator';
export type AppLanguage = 'en' | 'ta' | 'hi';

export interface User {
  id: string;
  name: string;
  phone: string;
  email?: string;
  role: UserRole;
  location?: string;
  district?: string;
  state?: string;
  preferredLanguage: AppLanguage;
  avatarUrl?: string;
}

export interface RecommendationParams {
  district: string;
  state: string;
  annual_rainfall_mm: number;
  max_temperature_c: number;
  min_temperature_c: number;
  altitude_m: number;
  humidity_percent: number;
  land_holding_acres: number;
  primary_purpose: 'Dairy' | 'Draft' | 'Dual' | 'Meat' | 'Fiber';
  budget_inr: number;
  experience_years: number;
  available_fodder_kg_per_day: number;
  water_availability: 'High' | 'Medium' | 'Low';
  housing_type: 'Free Range' | 'Semi-Intensive' | 'Intensive';
  market_distance_km: number;
  veterinary_access: 'Good' | 'Moderate' | 'Poor';
  target_species: 'Cattle';
}

export interface FeatureImportance {
  feature_name: string;
  importance_score: number;
  direction: 'positive' | 'negative' | 'neutral';
}

export interface BreedMasterInfo {
  Breed_ID: string;
  Breed_Name: string;
  Breed_Type: string;
  Origin_State: string;
  Milk_Yield_Liters_Day: number | string;
  Meat_Productivity: string;
  Disease_Resistance: string;
  Climate_Adaptability: string;
  Feed_Requirement: string;
  Daily_Feed_Cost_INR: number | string;
  Maintenance_Cost_Monthly: number | string;
  Lifespan_Years: string;
  Sustainability_Score: string | number;
  Best_For: string;
  Description: string;
}

export interface FeedMasterInfo {
  Breed_ID?: string;
  Breed_Name?: string;
  Feed_Type: string;
  Morning_Feed: string;
  Evening_Feed: string;
  Mineral_Mixture: string;
  Water_Requirement: string;
  Daily_Feed_Cost_INR: number | string;
  Nutrition_Level: string;
  Protein_Percentage: string;
  Fiber_Percentage: string;
  Energy_Level: string;
  Recommended_Season: string;
  Suitable_Farming_Purpose: string;
  Remarks: string;
}

export interface DiseaseMasterInfo {
  Disease_ID?: string;
  Disease_Name: string;
  Affected_Species?: string;
  Symptoms: string;
  Cause: string;
  Severity: string;
  Disease_Category: string;
  Transmission_Mode: string;
  Prevention: string;
  Vaccine_Available: string;
  Treatment: string;
  Recovery_Period_Days: string | number;
  Risk_Level: string;
  High_Risk_Breeds: string;
  Climate_Risk: string;
  Estimated_Treatment_Cost_INR: number | string;
  Sustainability_Impact: string;
  Recommended_Action: string;
}

export interface VaccinationMasterInfo {
  Vaccine_ID?: string;
  Vaccine_Name: string;
  Disease: string;
  Target_Disease?: string;
  Species: string;
  Dose: string;
  First_Dose_Age: string;
  Booster_Interval: string;
  Administration_Route: string;
  Recommended_Season: string;
  Storage_Temperature: string;
  Estimated_Cost: number | string;
  Government_Subsidized?: string;
  Protection_Percentage: string | number;
  Veterinary_Remarks: string;
}

export interface ClimateMasterInfo {
  Climate_ID?: string;
  State: string;
  District: string;
  Climate_Type: string;
  Avg_Temperature_C: number | string;
  Avg_Humidity_Percent: number | string;
  Annual_Rainfall_mm: number | string;
  Heat_Index: string;
  Suitable_Breeds: string;
  Water_Availability: string;
  Drought_Risk: string;
  Flood_Risk: string;
  Sustainability_Score: number | string;
  Recommended_Farming_Type?: string;
  Recommended_Farming?: string;
  Remarks?: string;
}

export interface EconomicsMasterInfo {
  Economics_ID?: string;
  Breed_Name: string;
  Farming_Type?: string;
  Purchase_Cost_INR: number | string;
  Daily_Feed_Cost_INR: number | string;
  Monthly_Maintenance_Cost_INR: number | string;
  Annual_Medical_Cost_INR: number | string;
  Average_Milk_Yield_L_Day: number | string;
  Average_Meat_Yield_Kg: number | string;
  Expected_Annual_Income_INR: number | string;
  Net_Profit_INR: number | string;
  ROI_Percentage: number | string;
  Break_even_Period_Months: string;
  Sustainability_Score: number | string;
  Investment_Level: string;
  Risk_Level: string;
  Recommended_Farmer_Type: string;
}

export interface BreedRecommendation {
  breed_id: string;
  breed_name: string;
  species: string;
  suitability_score: number;
  confidence: number;
  key_advantages: string[];
  expected_yield: string;
  disease_resistance_rating: string;
  heat_tolerance_rating: string;
  origin_region: string;
  description: string;
  imageUrl?: string;
  xai_factors?: FeatureImportance[];
  breed_details?: BreedMasterInfo;
  feed_details?: FeedMasterInfo;
  disease_details?: DiseaseMasterInfo;
  vaccination_schedule?: VaccinationMasterInfo[];
  climate_details?: ClimateMasterInfo;
  economics_details?: EconomicsMasterInfo;
}

export interface RecommendationResult {
  id: string;
  created_at: string;
  params: RecommendationParams;
  recommendations: BreedRecommendation[];
  model_version: string;
  accuracy_confidence: number;
  breed_details?: BreedMasterInfo;
  feed_details?: FeedMasterInfo;
  disease_details?: DiseaseMasterInfo;
  vaccination_schedule?: VaccinationMasterInfo[];
  climate_details?: ClimateMasterInfo;
  economics_details?: EconomicsMasterInfo;
}

export interface LivestockAnimal {
  id: string;
  tag_number: string;
  name: string;
  species: 'Cattle';
  breed: string;
  age_months: number;
  gender: 'Female' | 'Male';
  weight_kg: number;
  health_status: 'Healthy' | 'Needs Attention' | 'Sick' | 'Quarantine';
  lactation_stage?: string;
  daily_milk_yield_liters?: number;
  last_vaccination_date?: string;
  qr_code_payload: string;
  notes?: string;
}

export interface MedicalRecord {
  id: string;
  animal_id: string;
  animal_tag: string;
  date: string;
  type: 'Vaccination' | 'Deworming' | 'Illness' | 'Checkup' | 'Surgery';
  description: string;
  veterinarian_name?: string;
  treatment_cost?: number;
  next_due_date?: string;
  status: 'Completed' | 'Pending' | 'Overdue';
}

export interface ChatMessage {
  id: string;
  sender: 'user' | 'assistant';
  text: string;
  timestamp: string;
  provider?: 'Gemini 2.5 Flash' | 'GPT-4o' | 'Claude 3.5' | string;
  piiMasked?: boolean;
  medicalDisclaimer?: boolean;
  isError?: boolean;
  conversationId?: string;
}

export interface GovernmentScheme {
  id: string;
  title: string;
  category: string;
  funding_percentage: string;
  eligibility: string;
  description: string;
  apply_url: string;
  sponsoring_body: string;
}

export interface WeatherData {
  temperature: number;
  humidity: number;
  thi_index: number;
  heat_stress_level: 'Normal' | 'Alert' | 'Warning' | 'Emergency';
  location_name: string;
  forecast_summary: string;
}
