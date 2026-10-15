import os
import time
import httpx
from typing import Dict, Any, List, Optional
from backend.app.services.llm.base_provider import BaseLLMProvider
from backend.app.services.llm.prompt_builder import format_history_for_gemini

class GeminiProvider(BaseLLMProvider):
    """Google Gemini 2.5 Flash Adapter (Default LLM Engine)."""

    def __init__(self, model_name: str = "gemini-2.5-flash"):
        self.model_name = model_name

    def get_provider_name(self) -> str:
        return f"Google Gemini ({self.model_name})"

    def generate_completion(
        self,
        user_prompt: str,
        system_prompt: str = "",
        conversation_history: Optional[List[Dict[str, str]]] = None,
        language: str = "en",
    ) -> Dict[str, Any]:
        api_key = os.getenv("GEMINI_API_KEY")
        if not api_key:
            raise ValueError("GEMINI_API_KEY is not set in environment.")

        # Build contents structure: history + current prompt
        contents = []
        if conversation_history:
            contents.extend(format_history_for_gemini(conversation_history))

        # Add the current user prompt
        contents.append({
            "role": "user",
            "parts": [{"text": user_prompt}]
        })

        url = f"https://generativelanguage.googleapis.com/v1beta/models/{self.model_name}:generateContent?key={api_key}"
        
        payload = {
            "contents": contents,
            "generationConfig": {
                "temperature": 0.2,  # Reduce temperature to minimize repetitive and generic responses
                "maxOutputTokens": 1024,
            }
        }
        if system_prompt:
            payload["systemInstruction"] = {
                "parts": [{"text": system_prompt}]
            }

        headers = {
            "Content-Type": "application/json"
        }

        start_time = time.time()
        
        try:
            response = httpx.post(url, json=payload, headers=headers, timeout=30.0)
            response.raise_for_status()
            res_data = response.json()
        except Exception as e:
            raise RuntimeError(f"Gemini API request failed: {e}")

        # Parse output
        try:
            candidate = res_data["candidates"][0]
            text = candidate["content"]["parts"][0]["text"]
        except (KeyError, IndexError) as parse_err:
            raise RuntimeError(f"Failed to parse Gemini API response: {parse_err}. Response data: {res_data}")

        # Try to extract tokens used
        tokens_used = res_data.get("usageMetadata", {}).get("totalTokenCount", 0)
        if not tokens_used:
            tokens_used = len(user_prompt.split()) + len(text.split())

        latency_ms = int((time.time() - start_time) * 1000)

        return {
            "provider": self.get_provider_name(),
            "response": text.strip(),
            "language": language,
            "tokens_used": tokens_used,
            "model": self.model_name,
            "latency_ms": latency_ms,
            "citations": ["Rashtriya Gokul Mission Guidelines", "NBAGR Native Breed Repository"],
        }
