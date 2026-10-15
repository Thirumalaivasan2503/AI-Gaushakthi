import os
import sys

# Ensure project root is on sys.path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import json
import numpy as np
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.ensemble import RandomForestClassifier, ExtraTreesClassifier, GradientBoostingClassifier, HistGradientBoostingClassifier
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score, confusion_matrix

from ml.dataset import generate_synthetic_agritech_dataset
from ml.pipeline import extract_feature_vector, BREED_LABEL_MAP, INV_BREED_LABEL_MAP, FEATURE_NAMES

def train_and_evaluate_candidate_models():
    print("==========================================================")
    print("AI-BASED INDIGENOUS LIVESTOCK BREED MODEL EVALUATION HUB")
    print("==========================================================")
    
    # 1. Generate / Load dataset
    raw_data = generate_synthetic_agritech_dataset(1500)
    X = np.array([extract_feature_vector(s) for s in raw_data])
    y = np.array([BREED_LABEL_MAP.get(s["target_recommended_breed"], 0) for s in raw_data])

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)

    candidate_models = {
        "Random Forest Classifier": RandomForestClassifier(n_estimators=100, max_depth=12, random_state=42),
        "Extra Trees Classifier": ExtraTreesClassifier(n_estimators=100, max_depth=12, random_state=42),
        "Gradient Boosting (XGBoost Equivalent)": GradientBoostingClassifier(n_estimators=100, learning_rate=0.1, random_state=42),
        "Hist Gradient Boosting (LightGBM Equivalent)": HistGradientBoostingClassifier(max_iter=100, learning_rate=0.1, random_state=42),
    }

    best_name = None
    best_model = None
    best_acc = -1.0
    results_summary = {}

    for name, model in candidate_models.items():
        model.fit(X_train, y_train)
        y_pred = model.predict(X_test)
        
        acc = accuracy_score(y_test, y_pred)
        prec = precision_score(y_test, y_pred, average="weighted", zero_division=0)
        rec = recall_score(y_test, y_pred, average="weighted", zero_division=0)
        f1 = f1_score(y_test, y_pred, average="weighted", zero_division=0)
        cv_scores = cross_val_score(model, X_train, y_train, cv=5)

        results_summary[name] = {
            "accuracy": round(float(acc), 4),
            "precision": round(float(prec), 4),
            "recall": round(float(rec), 4),
            "f1_score": round(float(f1), 4),
            "cv_mean_accuracy": round(float(cv_scores.mean()), 4),
        }

        print(f"\nModel: {name}")
        print(f"  -> Accuracy: {acc*100:.2f}% | F1: {f1:.4f} | CV Mean: {cv_scores.mean()*100:.2f}%")

        if acc > best_acc:
            best_acc = acc
            best_name = name
            best_model = model

    print(f"\n==========================================================")
    print(f"BEST PERFORMING CANDIDATE MODEL: {best_name} (Accuracy: {best_acc*100:.2f}%)")
    print(f"==========================================================")

    # Feature Importances for best model (if available)
    feature_importances = {}
    if hasattr(best_model, "feature_importances_"):
        imps = best_model.feature_importances_
        for fn, imp in zip(FEATURE_NAMES, imps):
            feature_importances[fn] = round(float(imp), 4)

    # Save model weights / metadata
    model_meta = {
        "best_model_name": best_name,
        "best_accuracy": best_acc,
        "results_summary": results_summary,
        "feature_importances": feature_importances,
        "breed_labels": BREED_LABEL_MAP,
    }

    with open("ml/best_model_meta.json", "w") as f:
        json.dump(model_meta, f, indent=2)

    return best_model, model_meta

if __name__ == "__main__":
    train_and_evaluate_candidate_models()
