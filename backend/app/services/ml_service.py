import os
import json
import joblib
from backend.app.machine_learning.explainable_ai import ExplainableAIEngineModule3A
from backend.app.machine_learning.trainer import train_and_persist_best_model

class MLServiceModule3A:
    _model = None
    _scaler = None
    _metadata = None

    @classmethod
    def load_artifacts(cls):
        saved_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "machine_learning", "saved_models")
        model_path = os.path.join(saved_dir, "best_model.joblib")
        scaler_path = os.path.join(saved_dir, "scaler.joblib")
        meta_path = os.path.join(saved_dir, "metadata.json")

        if os.path.exists(model_path) and os.path.exists(scaler_path) and os.path.exists(meta_path):
            cls._model = joblib.load(model_path)
            cls._scaler = joblib.load(scaler_path)
            with open(meta_path, "r") as f:
                cls._metadata = json.load(f)
        else:
            cls._model, cls._metadata = train_and_persist_best_model()

    @classmethod
    def predict(cls, req_data: dict) -> dict:
        if cls._metadata is None:
            cls.load_artifacts()
        
        return ExplainableAIEngineModule3A.generate_full_xai_response(req_data)

    @classmethod
    def trigger_retraining(cls) -> dict:
        cls._model, cls._metadata = train_and_persist_best_model()
        return {
            "status": "success",
            "message": "Retrained candidate models and selected best model.",
            "data": cls._metadata,
        }

    @classmethod
    def get_model_status(cls) -> dict:
        if cls._metadata is None:
            cls.load_artifacts()
        return {
            "status": "online",
            "active_model": cls._metadata.get("selected_model_name", "Gradient Boosting (XGBoost Equivalent)"),
            "cross_validation_accuracy": cls._metadata.get("best_accuracy", 0.7933),
            "version": "v3.1.0",
        }

    @classmethod
    def get_model_metrics(cls) -> dict:
        if cls._metadata is None:
            cls.load_artifacts()
        return {
            "status": "success",
            "data": cls._metadata.get("evaluations", {}),
        }
