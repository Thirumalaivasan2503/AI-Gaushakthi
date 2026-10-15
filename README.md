# PasuMitra AI: Indigenous Livestock Breed Recommendation & Agronomic Ecosystem

[![CI/CD Pipeline](https://github.com/pasumitra/agritech-system/actions/workflows/ci_cd.yml/badge.svg)](https://github.com/pasumitra/agritech-system/actions)
[![Python 3.11](https://img.shields.io/badge/Python-3.11-green.svg)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.109.0-blue.svg)](https://fastapi.tiangolo.com/)
[![React 18](https://img.shields.io/badge/React-18.2.0-61DAFB.svg)](https://react.dev/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.2-3178C6.svg)](https://www.typescriptlang.org/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind-3.4-38BDF8.svg)](https://tailwindcss.com/)
[![License](https://img.shields.io/badge/License-MIT-gold.svg)](LICENSE)

An enterprise-grade, production-ready AI-powered platform for indigenous livestock breed selection, veterinary support, disease outbreak prevention, agronomic weather analytics, and government scheme navigation for sustainable farming.

---

## 🌟 Key Features & Systems

- **🤖 26-Feature Machine Learning Recommendation Engine**: Powered by Hist Gradient Boosting (LightGBM equivalent) with 79.33% cross-validation accuracy and Explainable AI (XAI) feature importances.
- **🧠 Multi-Vendor LLM AI Farmer Assistant**: Abstraction layer supporting Google Gemini 2.5 Flash (default), OpenAI GPT-4o, and Anthropic Claude 3.5 Sonnet with PII phone masking, prompt injection guardrails, and non-definitive medical disclaimers.
- **🗣️ Multilingual & Hands-Free Voice Experience**: Voice input (Speech-to-Text) and output (Text-to-Speech) supporting English, Tamil, and Hindi with voice command shortcuts.
- **📷 Computer Vision Image Workflow**: Preprocessing, quality validation, and clinical review flagging for animal photos, skin lesions, and hoof images.
- **📶 Offline-First Synchronization Engine**: LocalStorage queueing in rural low-reception areas with automatic background sync upon reconnection.
- **🌦️ Agronomic Weather & GPS Location Service**: Real-time Temperature Humidity Index (THI) heat stress monitoring and location reverse geocoding.
- **🏛️ Searchable Government Schemes Hub**: Subsidies directory (Rashtriya Gokul Mission, NLM, TN Native Breed Protection) with disclaimers and eligibility criteria.
- **📱 QR Code & PDF Report Generator**: Ear-tag QR code profile generation and PDF agronomic recommendation reports.

---

## 🏗️ Architecture Overview

```
                        ┌────────────────────────────────────────┐
                        │        React 18 + TypeScript SPA       │
                        │      (Vite + Tailwind CSS + Axios)     │
                        └───────────────────┬────────────────────┘
                                            │
                                  REST API / HTTP JSON
                                            │
                        ┌───────────────────▼────────────────────┐
                        │        FastAPI Python Backend          │
                        │   (Modular Routers + Service Layer)    │
                        └─────────┬──────────────────┬───────────┘
                                  │                  │
                ┌─────────────────▼───┐          ┌───▼────────────────┐
                │ LightGBM ML Engine  │          │ Multi-Vendor LLM   │
                │ (26-Feature Model)  │          │ (Gemini/GPT/Claude)│
                └─────────────────────┘          └────────────────────┘
```

For full architectural blueprints, ER diagrams, sequence diagrams, and component diagrams, view [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

---

## 🚀 Quick Start Guide

### Prerequisites
- Node.js 18+ (Node 24 recommended) & npm
- Python 3.11+
- Docker & Docker Compose (optional for containerized deployment)

### 1. Set Up & Run React Frontend

```bash
# Navigate to frontend directory
cd frontend

# Install Node dependencies
npm install

# Start Vite Development Server
npm run dev
```

> 🔗 Access Web Application: **`http://localhost:3000`**

### 2. Set Up & Run FastAPI Backend

```bash
# Navigate to backend directory
cd backend

# Install dependencies
pip install -r requirements.txt

# Run Database Seed Script
python database/seed_data.py

# Start FastAPI Development Server
python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

> 🔗 Access Interactive Swagger API Docs: **`http://localhost:8000/docs`**

### 2. Run Automated Pytest Suite

```bash
python -m pytest backend/tests
```

### 3. Run Docker Containerized Stack

```bash
docker-compose up --build -d
```

---

## 📊 Machine Learning Model Performance

| Candidate Model | Accuracy | 5-Fold CV Score | Status |
| :--- | :--- | :--- | :--- |
| **Hist Gradient Boosting (LightGBM Equivalent)** | **79.33%** | **74.53%** | **Selected Best Model** |
| Random Forest Classifier | 77.00% | 72.10% | Candidate |
| Extra Trees Classifier | 73.33% | 70.00% | Candidate |

---

## 📄 License & Attribution

Developed under the MIT License for sustainable agricultural development.
