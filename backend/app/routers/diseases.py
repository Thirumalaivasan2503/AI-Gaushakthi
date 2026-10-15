from fastapi import APIRouter, HTTPException, Path, Query
from typing import Optional
from app.services.disease_master_service import DiseaseMasterService

router = APIRouter(tags=["Disease Knowledge Base"])

@router.get("/api/diseases")
@router.get("/api/v1/diseases")
def get_all_diseases():
    """
    Returns all disease information entries from disease_master.csv cached in memory.
    """
    diseases = DiseaseMasterService.get_all_diseases()
    return {
        "status": "success",
        "total": len(diseases),
        "data": diseases,
    }

@router.get("/api/diseases/search")
@router.get("/api/v1/diseases/search")
def search_diseases(q: Optional[str] = Query(None, description="Search query string for disease name, symptoms, cause or breed")):
    """
    Searches disease_master.csv based on symptoms, disease name, category, or high risk breeds.
    """
    results = DiseaseMasterService.search_diseases(q or "")
    return {
        "status": "success",
        "total": len(results),
        "query": q,
        "data": results,
    }

@router.get("/api/diseases/{disease_name}")
@router.get("/api/v1/diseases/{disease_name}")
def get_disease_by_name(disease_name: str = Path(..., description="Name or ID of the disease to retrieve")):
    """
    Returns complete information about a specific disease from disease_master.csv.
    Implements proper error handling if disease is not found.
    """
    disease_info = DiseaseMasterService.get_disease_by_name(disease_name)
    if not disease_info:
        raise HTTPException(
            status_code=404,
            detail=f"Disease '{disease_name}' not found in disease master knowledge base."
        )
    return {
        "status": "success",
        "data": disease_info,
    }
