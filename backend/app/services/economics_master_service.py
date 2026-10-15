import os
import logging
import pandas as pd
from typing import Dict, Any, List, Optional

logger = logging.getLogger("EconomicsMasterService")

BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
ECONOMICS_MASTER_CSV = os.path.join(BASE_DIR, "datasets", "economics_master.csv")


class EconomicsMasterService:
    _cached_economics_list: List[Dict[str, Any]] = []
    _cached_breed_map: Dict[str, Dict[str, Any]] = {}
    _is_loaded: bool = False

    @classmethod
    def load_economics_master(cls, csv_path: str = ECONOMICS_MASTER_CSV) -> bool:
        """
        Loads economics_master.csv using Pandas during FastAPI startup
        and caches data in memory for O(1) instant financial lookup.
        """
        try:
            if not os.path.exists(csv_path):
                logger.warning(f"economics_master.csv not found at {csv_path}.")
                return False

            df = pd.read_csv(csv_path)
            df = df.fillna("")

            economics_list = []
            breed_map = {}

            for _, row in df.iterrows():
                b_name = str(row.get("Breed_Name", "")).strip()
                
                # Support exact column names in CSV: Annual_Income_INR, Break_Even_Months, Recommended_For, Average_Milk_Yield_Liters_Day
                annual_income = row.get("Annual_Income_INR") if "Annual_Income_INR" in row else row.get("Expected_Annual_Income_INR", 0.0)
                break_even = row.get("Break_Even_Months") if "Break_Even_Months" in row else row.get("Break_even_Period_Months", row.get("Break_even_Period", ""))
                rec_farmer = row.get("Recommended_For") if "Recommended_For" in row else row.get("Recommended_Farmer_Type", "")
                milk_yield = row.get("Average_Milk_Yield_Liters_Day") if "Average_Milk_Yield_Liters_Day" in row else row.get("Average_Milk_Yield_L_Day", 0.0)
                
                e_dict = {
                    "Economics_ID": str(row.get("Economics_ID", "") or row.get("ID", "")),
                    "Breed_Name": b_name,
                    "Farming_Type": str(row.get("Purpose", "") or row.get("Farming_Type", "") or row.get("Breed_Type", "")),
                    "Purchase_Cost_INR": float(row.get("Purchase_Cost_INR", 0.0)) if str(row.get("Purchase_Cost_INR", "")).replace('.', '', 1).isdigit() else str(row.get("Purchase_Cost_INR", "")),
                    "Daily_Feed_Cost_INR": float(row.get("Daily_Feed_Cost_INR", 0.0)) if str(row.get("Daily_Feed_Cost_INR", "")).replace('.', '', 1).isdigit() else str(row.get("Daily_Feed_Cost_INR", "")),
                    "Monthly_Maintenance_Cost_INR": float(row.get("Monthly_Maintenance_Cost_INR", 0.0)) if str(row.get("Monthly_Maintenance_Cost_INR", "")).replace('.', '', 1).isdigit() else str(row.get("Monthly_Maintenance_Cost_INR", "")),
                    "Annual_Medical_Cost_INR": float(row.get("Annual_Medical_Cost_INR", 0.0)) if str(row.get("Annual_Medical_Cost_INR", "")).replace('.', '', 1).isdigit() else str(row.get("Annual_Medical_Cost_INR", "")),
                    "Average_Milk_Yield_L_Day": float(milk_yield) if str(milk_yield).replace('.', '', 1).isdigit() else str(milk_yield),
                    "Average_Meat_Yield_Kg": float(row.get("Average_Meat_Yield_Kg", 0.0)) if str(row.get("Average_Meat_Yield_Kg", "")).replace('.', '', 1).isdigit() else str(row.get("Average_Meat_Yield_Kg", "")),
                    "Expected_Annual_Income_INR": float(annual_income) if str(annual_income).replace('.', '', 1).isdigit() else str(annual_income),
                    "Net_Profit_INR": float(row.get("Net_Profit_INR", 0.0)) if str(row.get("Net_Profit_INR", "")).replace('.', '', 1).isdigit() else str(row.get("Net_Profit_INR", "")),
                    "ROI_Percentage": float(row.get("ROI_Percentage", 0.0)) if str(row.get("ROI_Percentage", "")).replace('.', '', 1).isdigit() else str(row.get("ROI_Percentage", "")),
                    "Break_even_Period_Months": f"{break_even} Months" if "Month" not in str(break_even) else str(break_even),
                    "Sustainability_Score": float(row.get("Sustainability_Score", 0.0)) if str(row.get("Sustainability_Score", "")).replace('.', '', 1).isdigit() else str(row.get("Sustainability_Score", "")),
                    "Investment_Level": str(row.get("Investment_Level", "")),
                    "Risk_Level": str(row.get("Risk_Level", "")),
                    "Recommended_Farmer_Type": str(rec_farmer),
                }
                economics_list.append(e_dict)

                # Key mapping
                key = b_name.lower()
                if key not in breed_map:
                    breed_map[key] = e_dict

                # Index token words e.g. "kangayam", "gir", "sahiwal", "ongole", "malabari"
                for token in key.split():
                    if len(token) > 2 and token not in ("goat", "cow", "cattle", "crossbred"):
                        if token not in breed_map:
                            breed_map[token] = e_dict

            cls._cached_economics_list = economics_list
            cls._cached_breed_map = breed_map
            cls._is_loaded = True
            logger.info(f"Successfully loaded and cached {len(economics_list)} economics financial records from economics_master.csv into memory.")
            return True

        except Exception as e:
            logger.error(f"Error loading economics_master.csv: {e}", exc_info=True)
            return False

    @classmethod
    def get_all_economics(cls) -> List[Dict[str, Any]]:
        if not cls._is_loaded:
            cls.load_economics_master()
        return cls._cached_economics_list

    @classmethod
    def get_economics_by_breed_name(cls, breed_name: str) -> Optional[Dict[str, Any]]:
        """
        Retrieves financial economics for a specific breed by name.
        """
        if not cls._is_loaded:
            cls.load_economics_master()

        query = breed_name.strip().lower()
        if not query:
            return cls._cached_economics_list[0] if cls._cached_economics_list else None

        # 1. Direct lookup
        if query in cls._cached_breed_map:
            return cls._cached_breed_map[query]

        # 2. Token match
        for key, e_dict in cls._cached_breed_map.items():
            if key in query or query in key:
                return e_dict

        # 3. Fallback search
        for e in cls._cached_economics_list:
            b_name = e["Breed_Name"].lower()
            if query in b_name or b_name in query:
                return e

        return cls._cached_economics_list[0] if cls._cached_economics_list else None
