import os
import logging
import pandas as pd
from typing import Dict, Any, List, Optional

logger = logging.getLogger("VaccinationMasterService")

BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
VACCINATION_MASTER_CSV = os.path.join(BASE_DIR, "datasets", "vaccination_master.csv")


class VaccinationMasterService:
    _cached_vaccinations_list: List[Dict[str, Any]] = []
    _cached_disease_map: Dict[str, List[Dict[str, Any]]] = {}
    _cached_species_map: Dict[str, List[Dict[str, Any]]] = {}
    _is_loaded: bool = False

    @classmethod
    def load_vaccination_master(cls, csv_path: str = VACCINATION_MASTER_CSV) -> bool:
        """
        Loads vaccination_master.csv using Pandas during FastAPI startup
        and caches data in memory for efficient access.
        """
        try:
            if not os.path.exists(csv_path):
                logger.warning(f"vaccination_master.csv not found at {csv_path}.")
                return False

            df = pd.read_csv(csv_path)
            df = df.fillna("")

            vaccinations_list = []
            disease_map = {}
            species_map = {}

            for _, row in df.iterrows():
                target_dis = str(row.get("Target_Disease", "") or row.get("Disease", ""))
                spec = str(row.get("Species", "Cattle"))
                
                v_dict = {
                    "Vaccine_ID": str(row.get("Vaccine_ID", "")),
                    "Vaccine_Name": str(row.get("Vaccine_Name", "")),
                    "Disease": target_dis,
                    "Target_Disease": target_dis,
                    "Species": spec,
                    "Dose": str(row.get("Dose_mL", "") or row.get("Dose", "")),
                    "First_Dose_Age": str(row.get("First_Dose_Age_Months", "") or row.get("First_Dose_Age", "")) + " Months",
                    "Booster_Interval": str(row.get("Booster_Interval_Months", "") or row.get("Booster_Interval", "")) + " Months",
                    "Administration_Route": str(row.get("Administration_Route", "")),
                    "Recommended_Season": str(row.get("Recommended_Season", "")),
                    "Storage_Temperature": str(row.get("Storage_Temperature", "")),
                    "Estimated_Cost": float(row.get("Estimated_Cost_INR", 0.0)) if str(row.get("Estimated_Cost_INR", "")).replace('.', '', 1).isdigit() else str(row.get("Estimated_Cost", "")),
                    "Government_Subsidized": str(row.get("Government_Subsidized", "")),
                    "Protection_Percentage": str(row.get("Protection_Percentage", "")) + "%",
                    "Veterinary_Remarks": str(row.get("Remarks", "") or row.get("Veterinary_Remarks", "")),
                }
                vaccinations_list.append(v_dict)

                # Index by Disease (lower case)
                d_key = target_dis.lower().strip()
                if d_key not in disease_map:
                    disease_map[d_key] = []
                disease_map[d_key].append(v_dict)

                # Index token words for disease
                for token in d_key.split():
                    if len(token) > 2 and token not in ("and", "the", "disease"):
                        if token not in disease_map:
                            disease_map[token] = []
                        if v_dict not in disease_map[token]:
                            disease_map[token].append(v_dict)

                # Index by Species
                s_key = spec.lower().strip()
                if s_key not in species_map:
                    species_map[s_key] = []
                species_map[s_key].append(v_dict)

            cls._cached_vaccinations_list = vaccinations_list
            cls._cached_disease_map = disease_map
            cls._cached_species_map = species_map
            cls._is_loaded = True
            logger.info(f"Successfully loaded and cached {len(vaccinations_list)} vaccination records from vaccination_master.csv into memory.")
            return True

        except Exception as e:
            logger.error(f"Error loading vaccination_master.csv: {e}", exc_info=True)
            return False

    @classmethod
    def get_all_vaccinations(cls) -> List[Dict[str, Any]]:
        if not cls._is_loaded:
            cls.load_vaccination_master()
        return cls._cached_vaccinations_list

    @classmethod
    def get_vaccinations_by_disease(cls, disease_name: str) -> List[Dict[str, Any]]:
        if not cls._is_loaded:
            cls.load_vaccination_master()

        query = disease_name.strip().lower()
        if not query:
            return cls._cached_vaccinations_list

        # Direct match
        if query in cls._cached_disease_map:
            return cls._cached_disease_map[query]

        # Partial match
        results = []
        for d_key, v_list in cls._cached_disease_map.items():
            if query in d_key or d_key in query:
                for v in v_list:
                    if v not in results:
                        results.append(v)
        return results if results else cls._cached_vaccinations_list[:5]

    @classmethod
    def get_vaccinations_by_species(cls, species: str) -> List[Dict[str, Any]]:
        if not cls._is_loaded:
            cls.load_vaccination_master()

        query = species.strip().lower()
        if not query:
            return cls._cached_vaccinations_list

        if query in cls._cached_species_map:
            return cls._cached_species_map[query]

        results = []
        for s_key, v_list in cls._cached_species_map.items():
            if query in s_key or s_key in query:
                for v in v_list:
                    if v not in results:
                        results.append(v)
        return results if results else cls._cached_vaccinations_list
