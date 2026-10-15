from fastapi import APIRouter, HTTPException, Path
from app.services.economics_master_service import EconomicsMasterService

router = APIRouter(tags=["Economics Knowledge Base"])

@router.get("/api/economics")
@router.get("/api/v1/economics")
def get_all_economics():
    """
    Returns all breed economics records from economics_master.csv cached in memory.
    """
    economics_records = EconomicsMasterService.get_all_economics()
    return {
        "status": "success",
        "total": len(economics_records),
        "data": economics_records,
    }

@router.get("/api/economics/{breed_name}")
@router.get("/api/v1/economics/{breed_name}")
def get_economics_by_breed_name(breed_name: str = Path(..., description="Name of the breed to retrieve financial economics for")):
    """
    Returns financial economics for a specific breed from economics_master.csv.
    """
    economics_record = EconomicsMasterService.get_economics_by_breed_name(breed_name)
    if not economics_record:
        raise HTTPException(
            status_code=404,
            detail=f"Financial economics for breed '{breed_name}' not found in economics master knowledge base."
        )
    return {
        "status": "success",
        "breed_name": breed_name,
        "data": economics_record,
    }
