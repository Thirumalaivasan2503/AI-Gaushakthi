import logging
from typing import List, Dict, Any
from backend.app.services.llm.dataset_loader import DatasetLoader

logger = logging.getLogger("PasuMitraBreedRetrievalService")

class BreedRetrievalService:
    """Specialized service to query, rank, and retrieve breed master records conversationally."""

    @classmethod
    def retrieve_breeds(cls, query: str, limit: int = 5) -> List[Dict[str, Any]]:
        """
        Retrieves the most relevant breed records from the cached dataset.
        Automatically analyzes all columns present in the dataset to filter and rank records.
        """
        df = DatasetLoader.get_dataset("breed")
        if df.empty:
            logger.warning("Breed master dataset is empty or not loaded.")
            return []

        records = DatasetLoader.get_records("breed")
        columns = df.columns.tolist()
        q_lower = query.lower()

        # Identify numeric vs string columns automatically
        numeric_cols = []
        string_cols = []
        for col in columns:
            if col == "Breed_ID":
                continue
            sample_vals = df[col].dropna().head(10).tolist()
            is_numeric = False
            if sample_vals:
                try:
                    float_converts = 0
                    for val in sample_vals:
                        if val == "":
                            continue
                        float(val)
                        float_converts += 1
                    if float_converts > 0:
                        is_numeric = True
                except ValueError:
                    pass
            if is_numeric:
                numeric_cols.append(col)
            else:
                string_cols.append(col)

        scored_breeds = []

        # Analyze keywords in query
        wants_high = any(w in q_lower for w in ["high", "maximum", "max", "highest", "greatest", "more", "rich"])
        wants_low = any(w in q_lower for w in ["low", "minimum", "min", "lowest", "cheap", "less", "affordable"])

        # Map queries to string keywords
        type_keywords = {
            "indigenous": ["indigenous", "native", "desi", "swadeshi", "local"],
            "foreign": ["foreign", "exotic", "exotic breed", "imported", "western", "jersey", "holstein"],
            "crossbreed": ["cross", "crossbred", "hybrid"]
        }

        # Detect target types in query
        target_types = []
        for key, keywords in type_keywords.items():
            if any(w in q_lower for w in keywords):
                target_types.append(key)

        for r in records:
            score = 0
            b_name = str(r.get("Breed_Name", "")).lower()

            # 1. Exact Name match gets highest boost
            if b_name in q_lower or any(token in q_lower for token in b_name.split() if len(token) > 3 and token not in ("goat", "cow", "cattle")):
                score += 100

            # 2. String Column Keyword Matching
            for col in string_cols:
                val = str(r.get(col, "")).lower()
                if col == "Breed_Type":
                    for t in target_types:
                        # Handle mapping for "foreign" in breed_master.csv vs query terms
                        if t in val or (t == "foreign" and "exotic" in val) or (t == "foreign" and "foreign" in val):
                            score += 30
                # Match general words from query in other string columns
                q_tokens = [w for w in q_lower.split() if len(w) > 3]
                for token in q_tokens:
                    if token in val:
                        score += 5

            # 3. Numeric Column Matching (e.g. Milk_Yield_Liters_Day)
            for col in numeric_cols:
                try:
                    num_val = float(r.get(col, 0))
                except (ValueError, TypeError):
                    num_val = 0.0

                col_lower = col.lower()
                is_target_property = False
                if "milk" in col_lower or "yield" in col_lower:
                    is_target_property = any(w in q_lower for w in ["milk", "yield", "milch", "production", "litre", "liter"])
                elif "cost" in col_lower or "maintenance" in col_lower:
                    is_target_property = any(w in q_lower for w in ["cost", "price", "budget", "maintenance", "expensive", "cheap"])
                elif "sustainability" in col_lower:
                    is_target_property = "sustainability" in q_lower
                elif "lifespan" in col_lower:
                    is_target_property = "lifespan" in q_lower

                if is_target_property:
                    if wants_high:
                        score += int(num_val * 2.0)
                    elif wants_low:
                        if "cost" in col_lower:
                            score += max(0, int((10000 - num_val) / 100))
                        else:
                            score += max(0, int((100 - num_val) / 2))
                    else:
                        if "milk" in col_lower or "yield" in col_lower:
                            score += int(num_val * 1.5)

            if score > 0:
                scored_breeds.append((score, r))

        # Sort by score descending
        scored_breeds.sort(key=lambda x: x[0], reverse=True)

        # Retrieve unique records by Breed_Name
        top_records = []
        seen = set()
        for _, r in scored_breeds:
            name = r.get("Breed_Name")
            if name not in seen:
                seen.add(name)
                top_records.append(r)
            if len(top_records) == limit:
                break

        # Fallback to default records sorted by first numeric column (e.g., milk yield) descending
        if not top_records:
            target_col = numeric_cols[0] if numeric_cols else columns[1]
            def get_sort_val(x):
                try:
                    return float(x.get(target_col, 0))
                except (ValueError, TypeError):
                    return 0.0
            sorted_records = sorted(records, key=get_sort_val, reverse=True)
            for r in sorted_records:
                name = r.get("Breed_Name")
                if name not in seen:
                    seen.add(name)
                    top_records.append(r)
                if len(top_records) == limit:
                    break

        return top_records
