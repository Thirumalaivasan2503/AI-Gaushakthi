import os
import logging
import pandas as pd
from typing import Dict, Any, List, Optional

logger = logging.getLogger("DiseaseMasterService")

BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
DISEASE_MASTER_CSV = os.path.join(BASE_DIR, "datasets", "disease_master.csv")


class DiseaseMasterService:
    _cached_diseases_list: List[Dict[str, Any]] = []
    _cached_diseases_map: Dict[str, Dict[str, Any]] = {}
    _is_loaded: bool = False

    @classmethod
    def load_disease_master(cls, csv_path: str = DISEASE_MASTER_CSV) -> bool:
        """
        Loads disease_master.csv using Pandas during FastAPI startup
        and caches data in memory for O(1) efficient access.
        """
        try:
            if not os.path.exists(csv_path):
                logger.warning(f"disease_master.csv not found at {csv_path}.")
                return False

            df = pd.read_csv(csv_path)
            df = df.fillna("")

            diseases_list = []
            diseases_map = {}

            for _, row in df.iterrows():
                disease_dict = {
                    "Disease_ID": str(row.get("Disease_ID", "")),
                    "Disease_Name": str(row.get("Disease_Name", "")),
                    "Affected_Species": str(row.get("Affected_Species", "")),
                    "Symptoms": str(row.get("Symptoms", "")),
                    "Cause": str(row.get("Cause", "")),
                    "Severity": str(row.get("Severity", "")),
                    "Disease_Category": str(row.get("Disease_Category", "")),
                    "Transmission_Mode": str(row.get("Transmission_Mode", "")),
                    "Prevention": str(row.get("Prevention", "")),
                    "Vaccine_Available": str(row.get("Vaccine_Available", "")),
                    "Treatment": str(row.get("Treatment", "")),
                    "Recovery_Period_Days": str(row.get("Recovery_Period_Days", "")),
                    "Risk_Level": str(row.get("Risk_Level", "")),
                    "High_Risk_Breeds": str(row.get("High_Risk_Breeds", "")),
                    "Climate_Risk": str(row.get("Climate_Risk", "")),
                    "Estimated_Treatment_Cost_INR": float(row.get("Estimated_Treatment_Cost_INR", 0.0)) if str(row.get("Estimated_Treatment_Cost_INR", "")).replace('.', '', 1).isdigit() else str(row.get("Estimated_Treatment_Cost_INR", "")),
                    "Sustainability_Impact": str(row.get("Sustainability_Impact", "")),
                    "Recommended_Action": str(row.get("Recommended_Action", "")),
                }
                diseases_list.append(disease_dict)

                # Register lookup keys (id, lower disease name, tokens)
                d_id = disease_dict["Disease_ID"].lower()
                d_name = disease_dict["Disease_Name"].lower()

                diseases_map[d_id] = disease_dict
                diseases_map[d_name] = disease_dict

                # Index token words e.g. "foot", "mouth", "mastitis", "lumpy", "brucellosis", "anthrax", "black", "quarter"
                for token in d_name.split():
                    if len(token) > 2 and token not in ("and", "the", "disease", "skin"):
                        if token not in diseases_map:
                            diseases_map[token] = disease_dict

            cls._cached_diseases_list = diseases_list
            cls._cached_diseases_map = diseases_map
            cls._is_loaded = True
            logger.info(f"Successfully loaded and cached {len(diseases_list)} disease entries from disease_master.csv into memory.")
            return True

        except Exception as e:
            logger.error(f"Error loading disease_master.csv: {e}", exc_info=True)
            return False

    @classmethod
    def get_all_diseases(cls) -> List[Dict[str, Any]]:
        if not cls._is_loaded:
            cls.load_disease_master()
        return cls._cached_diseases_list

    @classmethod
    def get_disease_by_name(cls, disease_name: str) -> Optional[Dict[str, Any]]:
        """
        Retrieves disease information based on disease name or ID.
        Performs exact or fuzzy token matching.
        """
        if not cls._is_loaded:
            cls.load_disease_master()

        query = disease_name.strip().lower()
        if not query or query in ("none", "null", "n/a", "no"):
            return None

        # 1. Direct lookup
        if query in cls._cached_diseases_map:
            return cls._cached_diseases_map[query]

        # 2. Token match
        for key, disease_dict in cls._cached_diseases_map.items():
            if key in query or query in key:
                return disease_dict

        # 3. Fallback partial match
        for d in cls._cached_diseases_list:
            d_name = d["Disease_Name"].lower()
            if query in d_name or d_name in query:
                return d

        return None

    @classmethod
    def search_diseases(cls, query: str) -> List[Dict[str, Any]]:
        """
        Searches diseases based on query string across name, symptoms, cause, category, or high risk breeds.
        """
        if not cls._is_loaded:
            cls.load_disease_master()

        q = query.strip().lower()
        if not q:
            return cls._cached_diseases_list

        results = []
        seen_ids = set()

        for d in cls._cached_diseases_list:
            d_id = d["Disease_ID"]
            if d_id in seen_ids:
                continue

            searchable = f"{d['Disease_Name']} {d['Symptoms']} {d['Cause']} {d['Disease_Category']} {d['High_Risk_Breeds']} {d['Affected_Species']}".lower()
            if q in searchable or any(term in searchable for term in q.split()):
                results.append(d)
                seen_ids.add(d_id)

        return results
