import os
import logging
from typing import Dict, Any

logger = logging.getLogger("FirebaseService")

_firebase_initialized = False

try:
    import firebase_admin
    from firebase_admin import auth, credentials
    
    cred_path = os.getenv("FIREBASE_ADMIN_CREDENTIALS")
    if cred_path and os.path.exists(cred_path):
        cred = credentials.Certificate(cred_path)
        firebase_admin.initialize_app(cred)
        _firebase_initialized = True
        logger.info("Firebase Admin SDK initialized with certificate from %s", cred_path)
    elif not firebase_admin._apps:
        try:
            # Check if default project ID or GOOGLE_APPLICATION_CREDENTIALS exists
            if os.getenv("GOOGLE_CLOUD_PROJECT") or os.getenv("GOOGLE_APPLICATION_CREDENTIALS"):
                firebase_admin.initialize_app()
                _firebase_initialized = True
                logger.info("Firebase Admin SDK initialized with default credentials")
        except Exception as e:
            logger.warning("Firebase Admin default init skipped: %s", str(e))
except Exception as err:
    logger.warning("firebase_admin library loading error: %s", str(err))

class FirebaseService:
    @staticmethod
    def verify_id_token(id_token: str) -> Dict[str, Any]:
        """
        Verifies a Firebase ID token.
        Returns a dict containing 'uid', 'phone_number', etc.
        Supports development/testing tokens gracefully.
        """
        if not id_token:
            raise ValueError("Firebase ID Token must not be empty")

        # 1. Dev / Test mode simulated token handling
        if id_token.startswith("dev_firebase_") or id_token.startswith("mock_firebase_") or id_token.startswith("jwt_access_token_"):
            logger.info("Dev/Test mode: accepting simulated token %s...", id_token[:20])
            uid = f"fb_uid_{abs(hash(id_token))}"
            return {
                "uid": uid,
                "phone_number": "+919566405680",
                "auth_time": 1700000000,
                "firebase": {"sign_in_provider": "phone"},
            }

        # 2. Live Firebase Admin SDK verification
        if _firebase_initialized:
            try:
                decoded_claims = auth.verify_id_token(id_token)
                return decoded_claims
            except Exception as exc:
                logger.error("Failed to verify Firebase ID token: %s", exc)
                raise ValueError(f"Invalid or expired Firebase ID token: {str(exc)}")

        # Fallback for mock/test token in non-initialized environments
        if len(id_token) > 10:
            uid = f"fb_uid_{abs(hash(id_token))}"
            return {
                "uid": uid,
                "phone_number": "+919566405680",
                "auth_time": 1700000000,
                "firebase": {"sign_in_provider": "phone"},
            }

        raise ValueError("Firebase Admin SDK is not configured and token is invalid.")
