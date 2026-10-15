from fastapi import APIRouter, HTTPException, Path
from app.services.climate_master_service import ClimateMasterService

router = APIRouter(tags=["Climate Knowledge Base"])

@router.get("/api/climate")
@router.get("/api/v1/climate")
def get_all_climate():
    """
    Returns all climate records from climate_master.csv cached in memory.
    """
    climate_records = ClimateMasterService.get_all_climate()
    return {
        "status": "success",
        "total": len(climate_records),
        "data": climate_records,
    }

@router.get("/api/climate/{state}")
@router.get("/api/v1/climate/{state}")
def get_climate_by_state(state: str = Path(..., description="State name e.g. Tamil Nadu")):
    """
    Returns climate records for a specific state from climate_master.csv.
    """
    climate_records = ClimateMasterService.get_climate_by_state(state)
    if not climate_records:
        raise HTTPException(
            status_code=404,
            detail=f"Climate records for state '{state}' not found in climate master knowledge base."
        )
    return {
        "status": "success",
        "state": state,
        "total": len(climate_records),
        "data": climate_records,
    }

@router.get("/api/climate/{state}/{district}")
@router.get("/api/v1/climate/{state}/{district}")
def get_climate_by_state_and_district(
    state: str = Path(..., description="State name e.g. Tamil Nadu"),
    district: str = Path(..., description="District name e.g. Erode or Coimbatore")
):
    """
    Returns climate details for a specific state and district from climate_master.csv.
    """
    climate_record = ClimateMasterService.get_climate_by_state_and_district(state, district)
    if not climate_record:
        raise HTTPException(
            status_code=404,
            detail=f"Climate details for '{district}, {state}' not found in climate master knowledge base."
        )
    return {
        "status": "success",
        "data": climate_record,
    }
