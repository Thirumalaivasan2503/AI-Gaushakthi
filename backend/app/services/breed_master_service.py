import os
import logging
import pandas as pd
from typing import Dict, Any, List, Optional

logger = logging.getLogger("BreedMasterService")

BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
BREED_MASTER_CSV = os.path.join(BASE_DIR, "datasets", "breed_master.csv")


class BreedMasterService:
    _cached_breeds_list: List[Dict[str, Any]] = []
    _cached_breeds_map: Dict[str, Dict[str, Any]] = {}
    _is_loaded: bool = False

    @classmethod
    def load_breed_master(cls, csv_path: str = BREED_MASTER_CSV) -> bool:
        """
        Loads breed_master.csv using Pandas during FastAPI startup
        and caches data in memory for O(1) lookup.
        """
        try:
            if not os.path.exists(csv_path):
                logger.warning(f"breed_master.csv not found at {csv_path}. Creating fallback entries.")
                return False

            df = pd.read_csv(csv_path)
            df = df.fillna("")

            breeds_list = []
            breeds_map = {}

            for _, row in df.iterrows():
                breed_dict = {
                    "Breed_ID": str(row.get("Breed_ID", "")),
                    "Breed_Name": str(row.get("Breed_Name", "")),
                    "Breed_Type": str(row.get("Breed_Type", "")),
                    "Origin_State": str(row.get("Origin_State", "")),
                    "Milk_Yield_Liters_Day": float(row.get("Milk_Yield_Liters_Day", 0.0)) if str(row.get("Milk_Yield_Liters_Day", "")).replace('.', '', 1).isdigit() else str(row.get("Milk_Yield_Liters_Day", "")),
                    "Meat_Productivity": str(row.get("Meat_Productivity", "")),
                    "Disease_Resistance": str(row.get("Disease_Resistance", "")),
                    "Climate_Adaptability": str(row.get("Climate_Adaptability", "")),
                    "Feed_Requirement": str(row.get("Feed_Requirement", "")),
                    "Daily_Feed_Cost_INR": float(row.get("Daily_Feed_Cost_INR", 0.0)) if str(row.get("Daily_Feed_Cost_INR", "")).replace('.', '', 1).isdigit() else str(row.get("Daily_Feed_Cost_INR", "")),
                    "Maintenance_Cost_Monthly": float(row.get("Maintenance_Cost_Monthly", 0.0)) if str(row.get("Maintenance_Cost_Monthly", "")).replace('.', '', 1).isdigit() else str(row.get("Maintenance_Cost_Monthly", "")),
                    "Lifespan_Years": str(row.get("Lifespan_Years", "")),
                    "Sustainability_Score": str(row.get("Sustainability_Score", "")),
                    "Best_For": str(row.get("Best_For", "")),
                    "Description": str(row.get("Description", "")),
                }
                breeds_list.append(breed_dict)
                
                # Register lookup keys (id, lower name, partial name)
                b_id = breed_dict["Breed_ID"].lower()
                b_name = breed_dict["Breed_Name"].lower()
                
                breeds_map[b_id] = breed_dict
                breeds_map[b_name] = breed_dict
                
                # Also index key tokens like 'kangayam', 'gir', 'sahiwal', 'ongole', 'malabari', 'hf', 'jersey'
                for token in b_name.split():
                    if len(token) > 2 and token not in ("goat", "cow", "cattle", "crossbred"):
                        breeds_map[token] = breed_dict

            cls._cached_breeds_list = breeds_list
            cls._cached_breeds_map = breeds_map
            cls._is_loaded = True
            logger.info(f"Successfully loaded and cached {len(breeds_list)} breeds from breed_master.csv into memory.")
            return True

        except Exception as e:
            logger.error(f"Error loading breed_master.csv: {e}", exc_info=True)
            return False

    @classmethod
    def get_all_breeds(cls) -> List[Dict[str, Any]]:
        if not cls._is_loaded:
            cls.load_breed_master()
        return cls._cached_breeds_list

    @classmethod
    def get_breed_by_name(cls, breed_name: str) -> Optional[Dict[str, Any]]:
        """
        Retrieves breed information based on predicted or requested breed name.
        Performs exact or fuzzy token matching.
        """
        if not cls._is_loaded:
            cls.load_breed_master()

        query = breed_name.strip().lower()
        if not query:
            return None

        # 1. Direct lookup
        if query in cls._cached_breeds_map:
            return cls._cached_breeds_map[query]

        # 2. Token match
        for key, breed_dict in cls._cached_breeds_map.items():
            if key in query or query in key:
                return breed_dict

        # 3. Fallback partial match
        for b in cls._cached_breeds_list:
            b_name = b["Breed_Name"].lower()
            if query in b_name or b_name in query:
                return b

        return None
