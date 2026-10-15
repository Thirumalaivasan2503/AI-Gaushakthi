import os
import logging
import pandas as pd
from typing import Dict, List, Any

logger = logging.getLogger("PasuMitraDatasetLoader")

# Determine base and dataset directories
# This resolves to backend root directory
BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
DATASETS_DIR = os.path.join(BASE_DIR, "datasets")

class DatasetLoader:
    _df_cache: Dict[str, pd.DataFrame] = {}
    _records_cache: Dict[str, List[Dict[str, Any]]] = {}
    _is_loaded = False

    DATASET_FILES = {
        "breed": "breed_master.csv",
        "feed": "feed_master.csv",
        "disease": "disease_master.csv",
        "vaccination": "vaccination_master.csv",
        "climate": "climate_master.csv",
        "economics": "economics_master.csv",
        "prediction": "livestock_training_dataset.csv"
    }

    @classmethod
    def load_all(cls) -> None:
        """Loads all 7 CSV datasets once and caches them in memory."""
        if cls._is_loaded:
            logger.info("Datasets are already loaded and cached.")
            return

        for name, filename in cls.DATASET_FILES.items():
            path = os.path.join(DATASETS_DIR, filename)
            if not os.path.exists(path):
                alt_path = os.path.join(os.getcwd(), "backend", "datasets", filename)
                if os.path.exists(alt_path):
                    path = alt_path
                else:
                    logger.error(f"Dataset path not found: {path} or {alt_path}")
                    continue

            try:
                df = pd.read_csv(path)
                df = df.fillna("")
                cls._df_cache[name] = df
                cls._records_cache[name] = df.to_dict(orient="records")
                logger.info(f"Successfully preloaded and cached {len(df)} records from {filename} (intent: {name}).")
            except Exception as e:
                logger.error(f"Failed to load dataset {filename}: {e}", exc_info=True)

        cls._is_loaded = True
        logger.info("All 7 livestock RAG datasets successfully loaded in memory.")

    @classmethod
    def get_dataset(cls, name: str) -> pd.DataFrame:
        """Returns the cached Pandas DataFrame for a dataset."""
        if not cls._is_loaded:
            cls.load_all()
        return cls._df_cache.get(name, pd.DataFrame())

    @classmethod
    def get_records(cls, name: str) -> List[Dict[str, Any]]:
        """Returns the cached records (list of dicts) for a dataset."""
        if not cls._is_loaded:
            cls.load_all()
        return cls._records_cache.get(name, [])
