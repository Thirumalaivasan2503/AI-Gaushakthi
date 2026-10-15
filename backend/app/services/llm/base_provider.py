from abc import ABC, abstractmethod
from typing import Dict, Any, List, Optional


class BaseLLMProvider(ABC):
    """Abstract LLM Provider Interface for multi-vendor model orchestration."""

    @abstractmethod
    def generate_completion(
        self,
        user_prompt: str,
        system_prompt: str = "",
        conversation_history: Optional[List[Dict[str, str]]] = None,
        language: str = "en",
    ) -> Dict[str, Any]:
        """
        Generate a response from the LLM.

        Args:
            user_prompt:          The current user question (already PII-masked).
            system_prompt:        Full system instruction string.
            conversation_history: List of prior turns [{"role": "user"|"assistant", "content": "..."}].
            language:             Target response language code (en | ta | hi).

        Returns:
            dict with keys: provider, response, language, tokens_used, model, latency_ms
        """

    @abstractmethod
    def get_provider_name(self) -> str:
        """Return a human-readable provider name."""
