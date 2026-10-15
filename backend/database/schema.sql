-- PostgreSQL Database Schema for Indigenous Livestock Breed System (Module 3B Production Ready)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. USERS TABLE
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    full_name VARCHAR(120) NOT NULL,
    mobile VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(30) NOT NULL DEFAULT 'farmer',
    language VARCHAR(10) NOT NULL DEFAULT 'en',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_mobile ON users(mobile);
CREATE INDEX idx_users_email ON users(email);

-- 2. FARMER PROFILES TABLE
CREATE TABLE IF NOT EXISTS farmer_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    state VARCHAR(100) NOT NULL,
    district VARCHAR(100) NOT NULL,
    village VARCHAR(100) NOT NULL,
    livestock_focus VARCHAR(150) DEFAULT 'Cattle & Goats',
    land_holding_acres NUMERIC(6, 2) DEFAULT 0.0,
    available_budget_inr NUMERIC(10, 2) DEFAULT 50000.0,
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. FARMS TABLE
CREATE TABLE IF NOT EXISTS farms (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    farmer_profile_id UUID NOT NULL REFERENCES farmer_profiles(id) ON DELETE CASCADE,
    farm_name VARCHAR(150) NOT NULL,
    climate_zone VARCHAR(100) NOT NULL,
    soil_type VARCHAR(100) NOT NULL,
    water_source VARCHAR(100) NOT NULL,
    grazing_area_acres NUMERIC(6, 2) DEFAULT 2.0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. LIVESTOCK TABLE
CREATE TABLE IF NOT EXISTS livestock (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    farmer_profile_id UUID NOT NULL REFERENCES farmer_profiles(id) ON DELETE CASCADE,
    animal_tag_id VARCHAR(80) NOT NULL,
    name VARCHAR(100) NOT NULL,
    breed VARCHAR(100) NOT NULL,
    species VARCHAR(50) NOT NULL,
    gender VARCHAR(20) NOT NULL,
    dob VARCHAR(30),
    age_years NUMERIC(4, 1),
    weight_kg NUMERIC(6, 1),
    health_status VARCHAR(50) DEFAULT 'healthy',
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. RECOMMENDATION HISTORY TABLE
CREATE TABLE IF NOT EXISTS recommendation_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    recommended_breed VARCHAR(100) NOT NULL,
    confidence_score NUMERIC(5, 2) NOT NULL,
    productivity_goal VARCHAR(100) NOT NULL,
    input_vector JSONB,
    xai_rationale JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. WEATHER CACHE TABLE
CREATE TABLE IF NOT EXISTS weather_cache (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    location_key VARCHAR(100) UNIQUE NOT NULL,
    temperature_c NUMERIC(4, 1),
    humidity_percent NUMERIC(4, 1),
    rainfall_mm NUMERIC(6, 1),
    climate_zone VARCHAR(100),
    heat_index_thi NUMERIC(5, 2),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 7. NOTIFICATIONS TABLE
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    body TEXT NOT NULL,
    category VARCHAR(50) DEFAULT 'general',
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 8. MEDIA FILES TABLE
CREATE TABLE IF NOT EXISTS media_files (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    file_title VARCHAR(150) NOT NULL,
    file_path TEXT NOT NULL,
    file_type VARCHAR(50) NOT NULL,
    file_size_bytes NUMERIC(10, 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 9. SYNCHRONIZATION QUEUE TABLE
CREATE TABLE IF NOT EXISTS synchronization_queue (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    action VARCHAR(80) NOT NULL,
    payload JSONB NOT NULL,
    status VARCHAR(30) DEFAULT 'pending',
    retry_count INT DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
