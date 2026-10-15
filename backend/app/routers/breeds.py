from fastapi import APIRouter, HTTPException, Path
from pydantic import BaseModel
from typing import List, Optional
from app.services.breed_master_service import BreedMasterService

router = APIRouter(tags=["Breed Knowledge Base"])

class ComparisonRequest(BaseModel):
    breed_ids: List[str]

@router.get("/api/breeds")
@router.get("/api/v1/breeds")
def get_all_breeds():
    """
    Returns all available breeds from breed_master.csv cached in memory.
    """
    breeds = BreedMasterService.get_all_breeds()
    return {
        "status": "success",
        "total": len(breeds),
        "data": breeds,
    }

@router.get("/api/breeds/{breed_name}")
@router.get("/api/v1/breeds/{breed_name}")
def get_breed_by_name(breed_name: str = Path(..., description="Name or ID of the breed to retrieve")):
    """
    Returns complete information about a specific breed from breed_master.csv.
    Implements proper error handling if breed is not found.
    """
    breed_info = BreedMasterService.get_breed_by_name(breed_name)
    if not breed_info:
        raise HTTPException(
            status_code=404,
            detail=f"Breed '{breed_name}' not found in breed master knowledge base."
        )
    return {
        "status": "success",
        "data": breed_info,
    }

@router.post("/api/breeds/compare")
@router.post("/api/v1/breeds/compare")
def compare_breeds(req: ComparisonRequest):
    all_breeds = BreedMasterService.get_all_breeds()
    matched = [
        b for b in all_breeds
        if b["Breed_ID"].lower() in [i.lower() for i in req.breed_ids]
        or b["Breed_Name"].lower() in [i.lower() for i in req.breed_ids]
    ]
    return {
        "status": "success",
        "message": f"Comparing {len(matched)} breeds",
        "data": matched,
    }
