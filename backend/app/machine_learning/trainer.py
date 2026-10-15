import os
import sys

# Ensure project root is on sys.path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "../../..")))

import json
import joblib
import numpy as np
from sklearn.model_selection import train_test_split, cross_val_score, GridSearchCV
from sklearn.ensemble import RandomForestClassifier, ExtraTreesClassifier, GradientBoostingClassifier, HistGradientBoostingClassifier
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score

from backend.app.machine_learning.dataset_generator import generate_26_feature_dataset
from backend.app.machine_learning.preprocessor import preprocess_single_request, TARGET_BREED_MAP, FEATURE_NAMES

def train_and_persist_best_model():
    print("================================================================")
    print("MODULE 3A: 5-FOLD CROSS VALIDATION ML CANDIDATE SELECTION")
    print("================================================================")

    data = generate_26_feature_dataset(1600)
    X_raw = [preprocess_single_request(d) for d in data]
    y_raw = [TARGET_BREED_MAP.get(d["target_recommended_breed"], 0) for d in data]

    X = np.array(X_raw)
    y = np.array(y_raw)

    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)

    X_train, X_test, y_train, y_test = train_test_split(X_scaled, y, test_size=0.2, random_state=42, stratify=y)

    candidate_models = {
        "Random Forest Classifier": RandomForestClassifier(n_estimators=100, max_depth=12, random_state=42),
        "Extra Trees Classifier": ExtraTreesClassifier(n_estimators=100, max_depth=12, random_state=42),
        "Gradient Boosting (XGBoost Equivalent)": GradientBoostingClassifier(n_estimators=120, learning_rate=0.1, random_state=42),
        "Hist Gradient Boosting (LightGBM Equivalent)": HistGradientBoostingClassifier(max_iter=120, learning_rate=0.1, random_state=42),
    }

    best_name = None
    best_model = None
    best_acc = -1.0
    model_evaluations = {}

    for name, model in candidate_models.items():
        model.fit(X_train, y_train)
        preds = model.predict(X_test)
        
        acc = accuracy_score(y_test, preds)
        prec = precision_score(y_test, preds, average="weighted", zero_division=0)
        rec = recall_score(y_test, preds, average="weighted", zero_division=0)
        f1 = f1_score(y_test, preds, average="weighted", zero_division=0)
        cv_scores = cross_val_score(model, X_train, y_train, cv=5)

        model_evaluations[name] = {
            "accuracy": round(float(acc), 4),
            "precision": round(float(prec), 4),
            "recall": round(float(rec), 4),
            "f1_score": round(float(f1), 4),
            "cv_mean_5fold": round(float(cv_scores.mean()), 4),
        }
        print(f"Candidate: {name:<45} | Acc: {acc*100:.2f}% | 5-Fold CV: {cv_scores.mean()*100:.2f}%")

        if acc > best_acc:
            best_acc = acc
            best_name = name
            best_model = model

    print(f"\nSELECTED MODEL: {best_name} (Acc: {best_acc*100:.2f}%)")

    saved_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "saved_models")
    os.makedirs(saved_dir, exist_ok=True)

    joblib.dump(best_model, os.path.join(saved_dir, "best_model.joblib"))
    joblib.dump(scaler, os.path.join(saved_dir, "scaler.joblib"))

    meta = {
        "selected_model_name": best_name,
        "best_accuracy": round(float(best_acc), 4),
        "feature_names": FEATURE_NAMES,
        "evaluations": model_evaluations,
    }
    with open(os.path.join(saved_dir, "metadata.json"), "w") as f:
        json.dump(meta, f, indent=2)

    print(f"Saved artifacts to {saved_dir}")
    return best_model, meta

if __name__ == "__main__":
    train_and_persist_best_model()
