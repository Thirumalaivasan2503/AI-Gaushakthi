import os
import logging
import pandas as pd
from typing import Dict, Any, List, Optional

logger = logging.getLogger("FeedMasterService")

BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
FEED_MASTER_CSV = os.path.join(BASE_DIR, "datasets", "feed_master.csv")


class FeedMasterService:
    _cached_feeds_list: List[Dict[str, Any]] = []
    _cached_feeds_map: Dict[str, Dict[str, Any]] = {}
    _is_loaded: bool = False

    @classmethod
    def load_feed_master(cls, csv_path: str = FEED_MASTER_CSV) -> bool:
        """
        Loads feed_master.csv using Pandas during FastAPI startup
        and caches data in memory for O(1) instant lookup.
        """
        try:
            if not os.path.exists(csv_path):
                logger.warning(f"feed_master.csv not found at {csv_path}.")
                return False

            df = pd.read_csv(csv_path)
            df = df.fillna("")

            feeds_list = []
            feeds_map = {}

            for _, row in df.iterrows():
                feed_dict = {
                    "Breed_ID": str(row.get("Breed_ID", "")),
                    "Breed_Name": str(row.get("Breed_Name", "")),
                    "Feed_Type": str(row.get("Feed_Type", "")),
                    "Morning_Feed": str(row.get("Morning_Feed", "")),
                    "Evening_Feed": str(row.get("Evening_Feed", "")),
                    "Mineral_Mixture": str(row.get("Mineral_Mixture", "")),
                    "Water_Requirement": str(row.get("Water_Requirement", "")),
                    "Daily_Feed_Cost_INR": float(row.get("Daily_Feed_Cost_INR", 0.0)) if str(row.get("Daily_Feed_Cost_INR", "")).replace('.', '', 1).isdigit() else str(row.get("Daily_Feed_Cost_INR", "")),
                    "Nutrition_Level": str(row.get("Nutrition_Level", "")),
                    "Protein_Percentage": str(row.get("Protein_Percentage", "")),
                    "Fiber_Percentage": str(row.get("Fiber_Percentage", "")),
                    "Energy_Level": str(row.get("Energy_Level", "")),
                    "Recommended_Season": str(row.get("Recommended_Season", "")),
                    "Suitable_Farming_Purpose": str(row.get("Suitable_Farming_Purpose", "")),
                    "Remarks": str(row.get("Remarks", "")),
                }
                feeds_list.append(feed_dict)

                # Register lookup keys (id, lower breed name, tokens)
                b_id = feed_dict["Breed_ID"].lower()
                b_name = feed_dict["Breed_Name"].lower()

                feeds_map[b_id] = feed_dict
                feeds_map[b_name] = feed_dict

                for token in b_name.split():
                    if len(token) > 2 and token not in ("goat", "cow", "cattle", "crossbred"):
                        feeds_map[token] = feed_dict

            cls._cached_feeds_list = feeds_list
            cls._cached_feeds_map = feeds_map
            cls._is_loaded = True
            logger.info(f"Successfully loaded and cached {len(feeds_list)} feed recommendations from feed_master.csv into memory.")
            return True

        except Exception as e:
            logger.error(f"Error loading feed_master.csv: {e}", exc_info=True)
            return False

    @classmethod
    def get_all_feeds(cls) -> List[Dict[str, Any]]:
        if not cls._is_loaded:
            cls.load_feed_master()
        return cls._cached_feeds_list

    @classmethod
    def get_feed_by_breed_name(cls, breed_name: str) -> Optional[Dict[str, Any]]:
        """
        Retrieves feed recommendation based on breed name.
        Performs token or fuzzy matching.
        """
        if not cls._is_loaded:
            cls.load_feed_master()

        query = breed_name.strip().lower()
        if not query:
            return None

        # 1. Direct lookup
        if query in cls._cached_feeds_map:
            return cls._cached_feeds_map[query]

        # 2. Token match
        for key, feed_dict in cls._cached_feeds_map.items():
            if key in query or query in key:
                return feed_dict

        # 3. Fallback partial match
        for f in cls._cached_feeds_list:
            f_name = f["Breed_Name"].lower()
            if query in f_name or f_name in query:
                return f

        return None
