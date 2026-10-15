import logging
from typing import List, Dict, Any
from backend.app.services.llm.dataset_loader import DatasetLoader

logger = logging.getLogger("PasuMitraFeedRetrievalService")

class FeedRetrievalService:
    """Specialized service to query, rank, and retrieve feed master records conversationally."""

    @classmethod
    def retrieve_feeds(cls, query: str, limit: int = 5) -> List[Dict[str, Any]]:
        """
        Retrieves the most relevant feed records from the cached dataset.
        Handles dynamic columns (like Suitable_Breeds or Breed_Name) and maps query categories.
        """
        df = DatasetLoader.get_dataset("feed")
        if df.empty:
            logger.warning("Feed master dataset is empty or not loaded.")
            return []

        records = DatasetLoader.get_records("feed")
        columns = df.columns.tolist()
        q_lower = query.lower()

        # Find breed column name dynamically
        breed_col = next((c for c in columns if c.lower() in ("suitable_breeds", "breed_name", "breed", "breeds")), None)

        # Classify string and numeric columns dynamically
        numeric_cols = []
        string_cols = []
        for col in columns:
            if col == "Feed_ID":
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

        scored_feeds = []

        # Analyze keywords in query
        wants_goat = any(w in q_lower for w in ["goat", "malabari", "kid", "buck", "doe"])
        wants_dairy = any(w in q_lower for w in ["dairy", "milk", "milch", "lactat", "yield"])
        wants_high = any(w in q_lower for w in ["high", "max", "highest", "more"])
        wants_low = any(w in q_lower for w in ["low", "min", "lowest", "cheap", "less"])

        for r in records:
            score = 0
            
            # 1. Match breed name in the breed column dynamically
            if breed_col:
                b_val = str(r.get(breed_col, "")).lower()
                if b_val in q_lower or any(token in q_lower for token in b_val.split() if len(token) > 3 and token not in ("goat", "cow", "cattle")):
                    score += 50

            # 2. Goat specific check
            suitable_species = str(r.get("Suitable_Species", "")).lower()
            if wants_goat:
                if "goat" in suitable_species or (breed_col and "goat" in str(r.get(breed_col, "")).lower()):
                    score += 40
                else:
                    score -= 10
            else:
                if "goat" in suitable_species:
                    score -= 10

            # 3. String columns keyword matching
            for col in string_cols:
                if col == breed_col:
                    continue
                val = str(r.get(col, "")).lower()
                q_tokens = [w for w in q_lower.split() if len(w) > 3]
                for token in q_tokens:
                    if token in val:
                        score += 5

            # 4. Numeric columns matching
            for col in numeric_cols:
                try:
                    num_val = float(r.get(col, 0))
                except (ValueError, TypeError):
                    num_val = 0.0

                col_lower = col.lower()
                is_target_property = False
                if "protein" in col_lower:
                    is_target_property = "protein" in q_lower
                elif "fiber" in col_lower:
                    is_target_property = "fiber" in q_lower
                elif "cost" in col_lower or "price" in col_lower:
                    is_target_property = any(w in q_lower for w in ["cost", "price", "budget", "cheap"])

                if is_target_property:
                    if wants_high:
                        score += int(num_val * 2.0)
                    elif wants_low:
                        score += max(0, int((100 - num_val) / 2))
                    else:
                        score += int(num_val * 1.0)

            if score > 0:
                scored_feeds.append((score, r))

        # Sort by score descending
        scored_feeds.sort(key=lambda x: x[0], reverse=True)

        # Retrieve unique records
        top_records = []
        seen = set()
        for _, r in scored_feeds:
            b_name = r.get(breed_col or "Breed_Name") or "General"
            f_name = r.get("Feed_Name") or r.get("Feed_Type") or "Feed"
            unique_key = f"{b_name}-{f_name}"
            if unique_key not in seen:
                seen.add(unique_key)
                top_records.append(r)
            if len(top_records) == limit:
                break

        # Fallback to general default records of the category if no records matched
        if not top_records:
            logger.info("No specific query matches. Returning default cached feed records.")
            for r in records:
                b_name = r.get(breed_col or "Breed_Name") or "General"
                f_name = r.get("Feed_Name") or r.get("Feed_Type") or "Feed"
                unique_key = f"{b_name}-{f_name}"
                if "goat" not in str(r.get("Suitable_Species", "")).lower() and unique_key not in seen:
                    seen.add(unique_key)
                    top_records.append(r)
                if len(top_records) == limit:
                    break
            if len(top_records) < limit:
                for r in records:
                    b_name = r.get(breed_col or "Breed_Name") or "General"
                    f_name = r.get("Feed_Name") or r.get("Feed_Type") or "Feed"
                    unique_key = f"{b_name}-{f_name}"
                    if unique_key not in seen:
                        seen.add(unique_key)
                        top_records.append(r)
                    if len(top_records) == limit:
                        break

        return top_records
