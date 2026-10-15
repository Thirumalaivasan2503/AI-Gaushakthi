import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/authentication/presentation/role_selection_screen.dart';
import '../../features/authentication/presentation/language_selection_screen.dart';
import '../../features/authentication/presentation/login_screen.dart';
import '../../features/authentication/presentation/register_screen.dart';
import '../../features/authentication/presentation/otp_verification_screen.dart';
import '../../features/authentication/presentation/forgot_password_screen.dart';
import '../../features/authentication/presentation/change_password_screen.dart';
import '../../features/authentication/presentation/controllers/auth_controller.dart';
import '../../features/authentication/domain/models/auth_state.dart';
import '../../features/authentication/domain/user_role.dart';

import '../../features/home/presentation/main_navigation_screen.dart';
import '../../features/recommendation/presentation/recommendation_screen.dart';
import '../../features/recommendation/presentation/ai_dashboard_screen.dart';
import '../../features/recommendation/presentation/recommendation_history_screen.dart';
import '../../features/recommendation/presentation/prediction_details_screen.dart';

import '../../features/assistant/presentation/ai_assistant_screen.dart';

import '../../features/knowledge/presentation/knowledge_hub_screen.dart';
import '../../features/knowledge/presentation/breed_encyclopedia_screen.dart';
import '../../features/knowledge/presentation/breed_detail_screen.dart';
import '../../features/knowledge/presentation/breed_comparison_screen.dart';
import '../../features/knowledge/presentation/government_schemes_screen.dart';

import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

import '../../features/farmer/presentation/farmer_dashboard_screen.dart';
import '../../features/farmer/presentation/farmer_profile_form_screen.dart';
import '../../features/farmer/presentation/livestock_list_screen.dart';
import '../../features/farmer/presentation/add_edit_livestock_screen.dart';
import '../../features/farmer/presentation/livestock_detail_screen.dart';
import '../../features/farmer/presentation/medical_vaccination_screen.dart';
import '../../features/farmer/presentation/feed_environmental_screen.dart';
import '../../features/farmer/presentation/document_upload_screen.dart';
import '../../features/farmer/presentation/farmer_insights_screen.dart';

import '../../features/veterinary/presentation/vet_telemetry_screen.dart';
import '../../features/veterinary/presentation/veterinary_dashboard_screen.dart';
import '../../features/veterinary/presentation/vet_report_review_screen.dart';
import '../../features/veterinary/presentation/disease_database_screen.dart';
import '../../features/veterinary/presentation/vet_consultation_screen.dart';

import '../../features/administrator/presentation/admin_dashboard_screen.dart';
import '../../features/administrator/presentation/admin_ai_analytics_screen.dart';
import '../../features/analytics/presentation/economic_analysis_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

/// GoRouter Navigation Provider with Role-based Guards & Module 4 Routes
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthRoute = state.matchedLocation.startsWith('/auth') ||
          state.matchedLocation == '/' ||
          state.matchedLocation == '/onboarding';

      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final userRole = authState.user?.role;

      if (isAuthenticated && isAuthRoute) {
        if (userRole == UserRole.veterinaryExpert) return '/vet-dashboard';
        if (userRole == UserRole.administrator) return '/admin-dashboard';
        return '/home';
      }

      return null;
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding Flow
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Authentication Routes
      GoRoute(
        path: '/auth/role',
        name: 'role_selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/auth/language',
        name: 'language_selection',
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/auth/otp',
        name: 'otp_verification',
        builder: (context, state) {
          final phone = state.extra as String? ?? '+91 98765 43210';
          return OtpVerificationScreen(phoneNumber: phone);
        },
      ),
      GoRoute(
        path: '/auth/forgot-password',
        name: 'forgot_password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/auth/change-password',
        name: 'change_password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),

      // Settings & AI Assistant Routes
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/ai-assistant',
        name: 'ai_assistant',
        builder: (context, state) => const AIAssistantScreen(),
      ),
      GoRoute(
        path: '/government-schemes',
        name: 'government_schemes',
        builder: (context, state) => const GovernmentSchemesScreen(),
      ),
      GoRoute(
        path: '/admin-ai-analytics',
        name: 'admin_ai_analytics',
        builder: (context, state) => const AdminAIAnalyticsScreen(),
      ),

      // Role-based Dashboards & Vet Routes
      GoRoute(
        path: '/vet-dashboard',
        name: 'vet_dashboard',
        builder: (context, state) => const VeterinaryDashboardScreen(),
      ),
      GoRoute(
        path: '/vet/reports',
        name: 'vet_reports',
        builder: (context, state) => const VetReportReviewScreen(),
      ),
      GoRoute(
        path: '/vet/diseases',
        name: 'vet_diseases',
        builder: (context, state) => const DiseaseDatabaseScreen(),
      ),
      GoRoute(
        path: '/vet/consultations',
        name: 'vet_consultations',
        builder: (context, state) => const VetConsultationScreen(),
      ),
      GoRoute(
        path: '/admin-dashboard',
        name: 'admin_dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),

      // Farmer Routes
      GoRoute(
        path: '/farmer/profile',
        name: 'farmer_profile',
        builder: (context, state) => const FarmerProfileFormScreen(),
      ),
      GoRoute(
        path: '/farmer/livestock',
        name: 'farmer_livestock_list',
        builder: (context, state) => const LivestockListScreen(),
      ),
      GoRoute(
        path: '/farmer/livestock/add',
        name: 'farmer_add_livestock',
        builder: (context, state) {
          final animalIdToEdit = state.extra as String?;
          return AddEditLivestockScreen(animalIdToEdit: animalIdToEdit);
        },
      ),
      GoRoute(
        path: '/farmer/livestock/:id',
        name: 'farmer_livestock_detail',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return LivestockDetailScreen(animalId: id);
        },
      ),
      GoRoute(
        path: '/farmer/medical-vaccination',
        name: 'farmer_medical_vaccination',
        builder: (context, state) => const MedicalVaccinationScreen(),
      ),
      GoRoute(
        path: '/farmer/feed-environmental',
        name: 'farmer_feed_environmental',
        builder: (context, state) => const FeedEnvironmentalScreen(),
      ),
      GoRoute(
        path: '/farmer/documents',
        name: 'farmer_documents',
        builder: (context, state) => const DocumentUploadScreen(),
      ),

      // AI Dashboard & History Routes
      GoRoute(
        path: '/ai-dashboard',
        name: 'ai_dashboard',
        builder: (context, state) => const AIDashboardScreen(),
      ),
      GoRoute(
        path: '/recommendation-history',
        name: 'recommendation_history',
        builder: (context, state) => const RecommendationHistoryScreen(),
      ),
      GoRoute(
        path: '/prediction-details',
        name: 'prediction_details',
        builder: (context, state) => const PredictionDetailsScreen(),
      ),

      // Knowledge Hub Sub-routes
      GoRoute(
        path: '/knowledge/breeds',
        name: 'knowledge_breeds',
        builder: (context, state) => const BreedEncyclopediaScreen(),
      ),
      GoRoute(
        path: '/knowledge/breeds/:id',
        name: 'knowledge_breed_detail',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return BreedDetailScreen(breedId: id);
        },
      ),
      GoRoute(
        path: '/knowledge/compare',
        name: 'knowledge_compare',
        builder: (context, state) => const BreedComparisonScreen(),
      ),

      // Main Navigation Shell
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainNavigationScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const FarmerDashboardScreen(),
          ),
          GoRoute(
            path: '/recommendation',
            name: 'recommendation',
            builder: (context, state) => const RecommendationScreen(),
          ),
          GoRoute(
            path: '/knowledge',
            name: 'knowledge',
            builder: (context, state) => const KnowledgeHubScreen(),
          ),
          GoRoute(
            path: '/notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Analytics & Insights
      GoRoute(
        path: '/farmer-insights',
        name: 'farmer_insights',
        builder: (context, state) => const FarmerInsightsScreen(),
      ),
      GoRoute(
        path: '/vet-telemetry',
        name: 'vet_telemetry',
        builder: (context, state) => const VetTelemetryScreen(),
      ),
      GoRoute(
        path: '/economic-analysis',
        name: 'economic_analysis',
        builder: (context, state) => const EconomicAnalysisScreen(),
      ),
    ],
  );
});
