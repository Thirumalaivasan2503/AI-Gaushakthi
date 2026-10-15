from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from app.core.security import decode_token

security = HTTPBearer()

def get_current_user_token_data(credentials: HTTPAuthorizationCredentials = Depends(security)) -> dict:
    token = credentials.credentials
    payload = decode_token(token)
    if not payload or "sub" not in payload:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication token or session expired",
        )
    return payload

def require_role(allowed_roles: list[str]):
    def role_checker(token_data: dict = Depends(get_current_user_token_data)):
        user_role = token_data.get("role", "")
        if user_role not in allowed_roles:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Access denied. User role '{user_role}' lacks permission for this resource.",
            )
        return token_data
    return role_checker

require_farmer = require_role(["ruralFarmer", "urbanFarmer", "farmer"])
require_vet = require_role(["veterinaryExpert", "vet"])
require_admin = require_role(["administrator", "admin"])
