from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    PROJECT_NAME: str = "Indigenous Livestock AgriTech API"
    VERSION: str = "2.0.0"
    API_V1_STR: str = ""
    
    # Security
    SECRET_KEY: str = "super_secret_jwt_key_pasumitra_indigenous_livestock_2026_prod"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24  # 1 day
    REFRESH_TOKEN_EXPIRE_DAYS: int = 30
    
    # Database
    DATABASE_URL: str = "postgresql://postgres:postgres@localhost:5432/indigenous_livestock_db"
    
    # CORS & Limits
    CORS_ORIGINS: list[str] = ["*"]

settings = Settings()
