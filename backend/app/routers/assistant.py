import os
import sys

# Ensure backend root is on sys.path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "../..")))

from fastapi import APIRouter, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from typing import Optional, List, Dict
import logging
import time
import uuid
from datetime import datetime, timezone
from backend.app.services.ai_assistant_service import ai_assistant_service_instance

logger = logging.getLogger("PasuMitraAssistantRouter")

router = APIRouter(prefix="/api/v1/assistant", tags=["AI Farm Assistant"])


class ChatRequest(BaseModel):
    message: str
    language: Optional[str] = "en"          # en, ta, hi
    provider: Optional[str] = None
    conversation_id: Optional[str] = None
    # Conversation history for multi-turn context
    # Format: [{"role": "user"|"assistant", "content": "..."}]
    conversation_history: Optional[List[Dict[str, str]]] = None


@router.post("/chat")
def chat_with_assistant(req: ChatRequest):
    start_time = time.time()
    req_timestamp = datetime.now(timezone.utc).isoformat()

    logger.info(
        "Incoming chat | lang=%s | provider=%s | conv_id=%s | history_turns=%d",
        req.language, req.provider, req.conversation_id,
        len(req.conversation_history or []),
    )

    # Validate empty or whitespace-only messages
    if not req.message or not req.message.strip():
        logger.warning("Rejected chat request due to empty message field")
        return JSONResponse(
            status_code=400,
            content={
                "success": False,
                "error": "Bad Request",
                "details": "Message content cannot be empty or whitespace only.",
                "timestamp": req_timestamp,
            },
        )

    conv_id = req.conversation_id or f"conv-{uuid.uuid4().hex[:12]}"

    try:
        result = ai_assistant_service_instance.chat_with_assistant(
            req.message,
            language=req.language or "en",
            provider_name=req.provider,
            conversation_id=conv_id,
            context_history=req.conversation_history
        )
        
        processing_time = f"{time.time() - start_time:.3f}s"
        
        return {
            "success": True,
            "message": "Chat response generated successfully",
            "response": result.get("response", ""),
            "provider": result.get("provider", req.provider or "Gemini"),
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "processing_time": processing_time,
            "conversation_id": conv_id
        }
    except Exception as e:
        logger.error(f"Error handling chat request: {str(e)}", exc_info=True)
        return JSONResponse(
            status_code=500,
            content={
                "success": False,
                "error": "Internal Server Error",
                "details": str(e),
                "timestamp": datetime.now(timezone.utc).isoformat()
            }
        )

@router.get("/history")
def get_chat_history():
    return {
        "status": "success",
        "data": [
            {"role": "user", "message": "Which breed is best for drought area?"},
            {"role": "assistant", "message": "Kangayam cattle is highly heat resilient up to 48°C."},
        ],
    }
