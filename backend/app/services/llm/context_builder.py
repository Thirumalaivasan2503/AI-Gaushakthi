import logging
from typing import List, Dict, Any

logger = logging.getLogger("PasuMitraContextBuilder")

class ContextBuilder:
    @classmethod
    def build_context(cls, records: List[Dict[str, Any]], intent: str) -> str:
        """Formats the top retrieved records into a structured context string for prompt integration."""
        if not records:
            return ""

        context_parts = []
        context_parts.append(f"### [Retrieved {intent.capitalize()} Knowledge Records (Top {len(records)})]")

        for i, rec in enumerate(records, 1):
            record_lines = [f"Record {i}:"]
            for key, val in rec.items():
                if isinstance(val, float):
                    val = f"{val:.2f}"
                record_lines.append(f"  - {key}: {val}")
            context_parts.append("\n".join(record_lines))

        return "\n\n".join(context_parts)
