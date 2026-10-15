from backend.app.services.ml_service import MLServiceModule3A

class PredictionControllerModule3A:
    @staticmethod
    def handle_predict(req_dict: dict) -> dict:
        return MLServiceModule3A.predict(req_dict)

    @staticmethod
    def handle_train() -> dict:
        return MLServiceModule3A.trigger_retraining()

    @staticmethod
    def handle_model_status() -> dict:
        return MLServiceModule3A.get_model_status()

    @staticmethod
    def handle_model_metrics() -> dict:
        return MLServiceModule3A.get_model_metrics()
