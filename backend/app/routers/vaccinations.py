from fastapi import APIRouter, HTTPException, Path
from app.services.vaccination_master_service import VaccinationMasterService

router = APIRouter(tags=["Vaccination Knowledge Base"])

@router.get("/api/vaccinations")
@router.get("/api/v1/vaccinations")
def get_all_vaccinations():
    """
    Returns all vaccination schedules from vaccination_master.csv cached in memory.
    """
    vaccinations = VaccinationMasterService.get_all_vaccinations()
    return {
        "status": "success",
        "total": len(vaccinations),
        "data": vaccinations,
    }

@router.get("/api/vaccinations/species/{species}")
@router.get("/api/v1/vaccinations/species/{species}")
def get_vaccinations_by_species(species: str = Path(..., description="Species name e.g. Cattle or Goat")):
    """
    Returns vaccination schedule filtered by species from vaccination_master.csv.
    """
    vaccinations = VaccinationMasterService.get_vaccinations_by_species(species)
    return {
        "status": "success",
        "species": species,
        "total": len(vaccinations),
        "data": vaccinations,
    }

@router.get("/api/vaccinations/{disease_name}")
@router.get("/api/v1/vaccinations/{disease_name}")
def get_vaccinations_by_disease(disease_name: str = Path(..., description="Name of the disease to retrieve vaccination schedule for")):
    """
    Returns vaccination schedule for a specific disease from vaccination_master.csv.
    """
    vaccinations = VaccinationMasterService.get_vaccinations_by_disease(disease_name)
    if not vaccinations:
        raise HTTPException(
            status_code=404,
            detail=f"Vaccination schedule for disease '{disease_name}' not found in vaccination master knowledge base."
        )
    return {
        "status": "success",
        "disease": disease_name,
        "total": len(vaccinations),
        "data": vaccinations,
    }
