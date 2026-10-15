import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';
import { MainLayout } from './components/layout/MainLayout';

// Auth Pages
import { LoginPage } from './pages/auth/LoginPage';
import { RegisterPage } from './pages/auth/RegisterPage';

// Farmer Pages
import { FarmerDashboardPage } from './pages/farmer/FarmerDashboardPage';
import { LivestockListPage } from './pages/farmer/LivestockListPage';
import { AddEditLivestockPage } from './pages/farmer/AddEditLivestockPage';
import { CowProfilePage } from './pages/farmer/CowProfilePage';
import { MedicalVaccinationPage } from './pages/farmer/MedicalVaccinationPage';
import { MilkQualityAnalysisPage } from './pages/farmer/MilkQualityAnalysisPage';

// Recommendation Pages
import { RecommendationFormPage } from './pages/recommendation/RecommendationFormPage';
import { RecommendationResultPage } from './pages/recommendation/RecommendationResultPage';
import { RecommendationHistoryPage } from './pages/recommendation/RecommendationHistoryPage';

// Assistant
import { AIAssistantPage } from './pages/assistant/AIAssistantPage';

// Ecosystem & Comparison Resources
import { KnowledgeHubPage } from './pages/knowledge/KnowledgeHubPage';
import { BreedComparisonPage } from './pages/knowledge/BreedComparisonPage';
import { ClimateAnalysisPage } from './pages/knowledge/ClimateAnalysisPage';
import { EconomicAnalysisPage } from './pages/admin/EconomicAnalysisPage';
import { GovernmentSchemesPage } from './pages/knowledge/GovernmentSchemesPage';

// Settings & Profile
import { SettingsPage } from './pages/settings/SettingsPage';
import { ProfilePage } from './pages/profile/ProfilePage';
import { NotificationsPage } from './pages/notifications/NotificationsPage';

// Protected Route Guard requiring JWT token authentication
const ProtectedRoute: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { isAuthenticated } = useAuth();
  if (!isAuthenticated) {
    return <Navigate to="/auth/login" replace />;
  }
  return <>{children}</>;
};

export const App: React.FC = () => {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          {/* Auth Flow */}
          <Route path="/auth/login" element={<LoginPage />} />
          <Route path="/auth/register" element={<RegisterPage />} />

          {/* Main App Layout protected by JWT authentication */}
          <Route
            element={
              <ProtectedRoute>
                <MainLayout />
              </ProtectedRoute>
            }
          >
            <Route path="/" element={<Navigate to="/home" replace />} />
            <Route path="/home" element={<FarmerDashboardPage />} />

            {/* Farmer Features */}
            <Route path="/farmer/livestock" element={<LivestockListPage />} />
            <Route path="/farmer/livestock/add" element={<AddEditLivestockPage />} />
            <Route path="/farmer/livestock/:id" element={<CowProfilePage />} />
            <Route path="/farmer/livestock/profile/:id" element={<CowProfilePage />} />
            <Route path="/farmer/medical-vaccination" element={<MedicalVaccinationPage />} />
            <Route path="/farmer/milk-analysis" element={<MilkQualityAnalysisPage />} />

            {/* Recommendation Engine */}
            <Route path="/recommendation" element={<RecommendationFormPage />} />
            <Route path="/prediction-details" element={<RecommendationResultPage />} />
            <Route path="/recommendation-history" element={<RecommendationHistoryPage />} />

            {/* AI Assistant */}
            <Route path="/ai-assistant" element={<AIAssistantPage />} />

            {/* Ecosystem Resources & Breed Comparison */}
            <Route path="/knowledge" element={<KnowledgeHubPage />} />
            <Route path="/knowledge/compare" element={<BreedComparisonPage />} />
            <Route path="/climate-analysis" element={<ClimateAnalysisPage />} />
            <Route path="/economic-analysis" element={<EconomicAnalysisPage />} />
            <Route path="/farmer/economic-analysis" element={<EconomicAnalysisPage />} />
            <Route path="/government-schemes" element={<GovernmentSchemesPage />} />

            {/* Settings & Profile */}
            <Route path="/settings" element={<SettingsPage />} />
            <Route path="/profile" element={<ProfilePage />} />
            <Route path="/notifications" element={<NotificationsPage />} />
          </Route>

          {/* Fallback */}
          <Route path="*" element={<Navigate to="/home" replace />} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
};

export default App;
