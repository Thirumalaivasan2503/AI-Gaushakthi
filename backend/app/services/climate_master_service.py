import os
import logging
import pandas as pd
from typing import Dict, Any, List, Optional

logger = logging.getLogger("ClimateMasterService")

BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CLIMATE_MASTER_CSV = os.path.join(BASE_DIR, "datasets", "climate_master.csv")


class ClimateMasterService:
    _cached_climate_list: List[Dict[str, Any]] = []
    _cached_state_map: Dict[str, List[Dict[str, Any]]] = {}
    _cached_state_district_map: Dict[str, Dict[str, Any]] = {}
    _is_loaded: bool = False

    @classmethod
    def load_climate_master(cls, csv_path: str = CLIMATE_MASTER_CSV) -> bool:
        """
        Loads climate_master.csv using Pandas during FastAPI startup
        and caches data in memory for efficient O(1) location lookup.
        """
        try:
            if not os.path.exists(csv_path):
                logger.warning(f"climate_master.csv not found at {csv_path}.")
                return False

            df = pd.read_csv(csv_path)
            df = df.fillna("")

            climate_list = []
            state_map = {}
            state_district_map = {}

            for _, row in df.iterrows():
                state = str(row.get("State", "")).strip()
                district = str(row.get("District", "")).strip()
                
                c_dict = {
                    "Climate_ID": str(row.get("Climate_ID", "")),
                    "State": state,
                    "District": district,
                    "Climate_Type": str(row.get("Climate_Type", "")),
                    "Avg_Temperature_C": float(row.get("Avg_Temperature_C", 0.0)) if str(row.get("Avg_Temperature_C", "")).replace('.', '', 1).isdigit() else str(row.get("Avg_Temperature_C", "")),
                    "Avg_Humidity_Percent": float(row.get("Avg_Humidity_Percent", 0.0)) if str(row.get("Avg_Humidity_Percent", "")).replace('.', '', 1).isdigit() else str(row.get("Avg_Humidity_Percent", "")),
                    "Annual_Rainfall_mm": float(row.get("Annual_Rainfall_mm", 0.0)) if str(row.get("Annual_Rainfall_mm", "")).replace('.', '', 1).isdigit() else str(row.get("Annual_Rainfall_mm", "")),
                    "Heat_Index": str(row.get("Heat_Index", "")),
                    "Suitable_Breeds": str(row.get("Suitable_Breeds", "")),
                    "Water_Availability": str(row.get("Water_Availability", "")),
                    "Drought_Risk": str(row.get("Drought_Risk", "")),
                    "Flood_Risk": str(row.get("Flood_Risk", "")),
                    "Sustainability_Score": float(row.get("Sustainability_Score", 0.0)) if str(row.get("Sustainability_Score", "")).replace('.', '', 1).isdigit() else str(row.get("Sustainability_Score", "")),
                    "Recommended_Farming": str(row.get("Recommended_Farming", "") or row.get("Recommended_Farming_Type", "")),
                    "Recommended_Farming_Type": str(row.get("Recommended_Farming", "") or row.get("Recommended_Farming_Type", "")),
                    "Remarks": str(row.get("Remarks", "")),
                }
                climate_list.append(c_dict)

                # Index by State
                s_key = state.lower()
                if s_key not in state_map:
                    state_map[s_key] = []
                state_map[s_key].append(c_dict)

                # Index by State + District
                sd_key = f"{state.lower()}:{district.lower()}"
                state_district_map[sd_key] = c_dict

            cls._cached_climate_list = climate_list
            cls._cached_state_map = state_map
            cls._cached_state_district_map = state_district_map
            cls._is_loaded = True
            logger.info(f"Successfully loaded and cached {len(climate_list)} climate location records from climate_master.csv into memory.")
            return True

        except Exception as e:
            logger.error(f"Error loading climate_master.csv: {e}", exc_info=True)
            return False

    @classmethod
    def get_all_climate(cls) -> List[Dict[str, Any]]:
        if not cls._is_loaded:
            cls.load_climate_master()
        return cls._cached_climate_list

    @classmethod
    def get_climate_by_state(cls, state: str) -> List[Dict[str, Any]]:
        if not cls._is_loaded:
            cls.load_climate_master()

        query = state.strip().lower()
        if not query:
            return cls._cached_climate_list

        if query in cls._cached_state_map:
            return cls._cached_state_map[query]

        # Partial match
        results = []
        for s_key, c_list in cls._cached_state_map.items():
            if query in s_key or s_key in query:
                for c in c_list:
                    if c not in results:
                        results.append(c)
        return results if results else cls._cached_climate_list[:5]

    @classmethod
    def get_climate_by_state_and_district(cls, state: str, district: str) -> Optional[Dict[str, Any]]:
        if not cls._is_loaded:
            cls.load_climate_master()

        sd_key = f"{state.strip().lower()}:{district.strip().lower()}"
        if sd_key in cls._cached_state_district_map:
            return cls._cached_state_district_map[sd_key]

        # Fallback to state match first item
        state_matches = cls.get_climate_by_state(state)
        if state_matches:
            for c in state_matches:
                if district.strip().lower() in c["District"].lower():
                    return c
            return state_matches[0]

        return cls._cached_climate_list[0] if cls._cached_climate_list else None
