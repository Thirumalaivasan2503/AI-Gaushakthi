import os
import sys
import json
import joblib
import pandas as pd
import numpy as np
from typing import Dict, Any, Tuple
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score

# Base directories
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BACKEND_DIR = os.path.dirname(BASE_DIR)
DATASET_PATH = os.path.join(BACKEND_DIR, "datasets", "livestock_training_dataset.csv")
SAVED_MODELS_DIR = os.path.join(BASE_DIR, "machine_learning", "saved_models")

FEATURE_COLS = [
    "State",
    "District",
    "Temperature_C",
    "Humidity_%",
    "Rainfall_mm",
    "Soil_Type",
    "Water_Availability",
    "Farm_Size_Acres",
    "Feed_Budget_INR",
    "Medical_Budget_INR",
    "Disease_History",
    "Vaccination_Status",
    "Livestock_Purpose",
    "Organic_Farming",
    "Climate_Zone",
    "Productivity_Goal",
]

TARGET_COL = "Recommended_Breed"


def train_and_save_rf_model(csv_path: str = DATASET_PATH) -> Tuple[Any, Dict[str, Any]]:
    """
    Loads livestock_training_dataset.csv using Pandas, performs preprocessing,
    trains a Random Forest model, and saves model artifacts using Joblib.
    """
    if not os.path.exists(csv_path):
        raise FileNotFoundError(f"Dataset file not found at: {csv_path}")

    print(f"Loading dataset with Pandas from: {csv_path}")
    df = pd.read_csv(csv_path)

    # 1. Preprocessing & Missing Value Handling
    df["Disease_History"] = df["Disease_History"].fillna("None")

    # 2. Categorical Encoding
    X = df[FEATURE_COLS].copy()
    y = df[TARGET_COL].copy()

    label_encoders: Dict[str, LabelEncoder] = {}
    categorical_cols = X.select_dtypes(include=["object", "string", "category"]).columns

    for col in categorical_cols:
        le = LabelEncoder()
        X[col] = le.fit_transform(X[col].astype(str))
        label_encoders[col] = le

    target_encoder = LabelEncoder()
    y_encoded = target_encoder.fit_transform(y)

    # 3. Train Test Split & Model Training
    X_train, X_test, y_train, y_test = train_test_split(
        X, y_encoded, test_size=0.2, random_state=42, stratify=y_encoded
    )

    rf_model = RandomForestClassifier(
        n_estimators=150,
        max_depth=12,
        random_state=42,
        class_weight="balanced"
    )
    rf_model.fit(X_train, y_train)

    # 4. Evaluation
    y_pred = rf_model.predict(X_test)
    acc = accuracy_score(y_test, y_pred)
    prec = precision_score(y_test, y_pred, average="weighted", zero_division=0)
    rec = recall_score(y_test, y_pred, average="weighted", zero_division=0)
    f1 = f1_score(y_test, y_pred, average="weighted", zero_division=0)
    cv_scores = cross_val_score(rf_model, X, y_encoded, cv=5)

    print(f"Random Forest Trained successfully.")
    print(f"Accuracy: {acc*100:.2f}% | 5-Fold CV Mean: {cv_scores.mean()*100:.2f}%")

    # 5. Extract Feature Importances
    importances = dict(zip(FEATURE_COLS, [round(float(val), 4) for val in rf_model.feature_importances_]))

    # 6. Save Artifacts using Joblib
    os.makedirs(SAVED_MODELS_DIR, exist_ok=True)
    model_path = os.path.join(SAVED_MODELS_DIR, "dataset_rf_model.joblib")
    preprocessor_path = os.path.join(SAVED_MODELS_DIR, "dataset_rf_preprocessor.joblib")
    metadata_path = os.path.join(SAVED_MODELS_DIR, "dataset_rf_metadata.json")

    joblib.dump(rf_model, model_path)
    
    preprocessor_artifacts = {
        "label_encoders": label_encoders,
        "target_encoder": target_encoder,
        "feature_cols": FEATURE_COLS,
        "categorical_cols": list(categorical_cols),
    }
    joblib.dump(preprocessor_artifacts, preprocessor_path)

    metadata = {
        "model_type": "Random Forest Classifier",
        "dataset_used": os.path.basename(csv_path),
        "total_samples": len(df),
        "accuracy": round(float(acc), 4),
        "precision": round(float(prec), 4),
        "recall": round(float(rec), 4),
        "f1_score": round(float(f1), 4),
        "cv_mean_accuracy": round(float(cv_scores.mean()), 4),
        "target_classes": list(target_encoder.classes_),
        "feature_importances": importances,
    }

    with open(metadata_path, "w") as f:
        json.dump(metadata, f, indent=2)

    print(f"Saved trained Random Forest model to: {model_path}")
    print(f"Saved preprocessors to: {preprocessor_path}")
    print(f"Saved metadata to: {metadata_path}")

    return rf_model, metadata


if __name__ == "__main__":
    train_and_save_rf_model()
