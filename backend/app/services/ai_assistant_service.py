import re
from typing import Dict, Any, List, Optional
from backend.app.services.llm.rag_service import rag_service_instance

class AIAssistantService:
    """Multi-vendor LLM Provider Orchestrator with RAG support (delegated to RAGService)."""

    def mask_pii_data(self, text: str) -> str:
        """Masks sensitive PII numbers (e.g. mobile numbers, Aadhar) before sending to LLM."""
        return rag_service_instance.mask_pii_data(text)

    def chat_with_assistant(
        self,
        user_prompt: str,
        language: str = "en",
        context_history: List[dict] = None,
        provider_name: str = None,
        conversation_id: str = None
    ) -> Dict[str, Any]:
        """Delegates chat request to the RAGService to search datasets and generate response."""
        return rag_service_instance.chat_with_rag(
            user_prompt=user_prompt,
            language=language,
            context_history=context_history,
            provider_name=provider_name,
            conversation_id=conversation_id
        )

ai_assistant_service_instance = AIAssistantService()
