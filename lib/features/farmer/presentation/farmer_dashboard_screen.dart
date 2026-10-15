import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

import '../../../core/widgets/cards/animal_card.dart';
import '../../../core/widgets/cards/expense_card.dart';
import '../../../core/widgets/cards/farmer_profile_header.dart';
import '../../../core/widgets/cards/glass_card.dart';
import '../../../core/widgets/cards/login_card.dart';
import '../../../core/widgets/feedback/loading_overlay.dart';
import '../../../core/widgets/feedback/vaccination_timeline.dart';
import '../../../core/widgets/navigation/network_status_banner_widget.dart';

import '../../../core/services/weather_service.dart';
import '../../../core/services/sync_service.dart';

import '../domain/models/farmer_profile_model.dart';
import 'controllers/farmer_controller.dart';

/// Comprehensive Farmer Module Hub Dashboard
class FarmerDashboardScreen extends ConsumerWidget {
  const FarmerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmerState = ref.watch(farmerControllerProvider);
    final profile = farmerState.profile ?? const FarmerProfileModel(
      id: '1',
      userId: '1',
      fullName: 'Ramesh Kumar',
      email: 'ramesh.farmer@agritech.in',
      mobile: '+91 98765 43210',
      state: 'Tamil Nadu',
      district: 'Coimbatore',
      village: 'Pollachi',
      farmName: 'GreenPastures Farm',
    );
    final animals = farmerState.livestockList;
    final syncService = ref.watch(syncServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PasuMitra AI • Farmer Hub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.wb_sunny_outlined),
            onPressed: () => context.push('/ai-dashboard'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: farmerState.isLoading,
        message: 'Synchronizing farm data...',
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Network Connectivity & Offline Banner
                const NetworkStatusBannerWidget(),

                Padding(
                  padding: AppSpacing.paddingLg,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Farmer Profile Banner Header
                      FarmerProfileHeaderWidget(
                        profile: profile,
                        onEditTap: () => context.push('/farmer/profile'),
                      ),
                      const SizedBox(height: 20),

                      // Agronomic Weather Card
                      _buildWeatherCard(context, ref),

                      const SizedBox(height: 20),
                      // Quick Summary Statistics Grid
                      Text('Farm Overview', style: AppTypography.headlineSmall),
                      const SizedBox(height: 12),

                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        children: [
                          _buildSummaryTile(
                            context,
                            title: 'Total Livestock',
                            value: animals.length.toString(),
                            subtitle: 'Registered',
                            icon: Icons.pets,
                            color: AppColors.primary,
                          ),
                          _buildSummaryTile(
                            context,
                            title: 'Healthy Animals',
                            value: farmerState.healthyCount.toString(),
                            subtitle: 'Normal',
                            icon: Icons.health_and_safety,
                            color: AppColors.success,
                          ),
                          _buildSummaryTile(
                            context,
                            title: 'Vaccine Due',
                            value: farmerState.vaccineDueCount.toString(),
                            subtitle: 'Next 30 Days',
                            icon: Icons.vaccines,
                            color: AppColors.warning,
                          ),
                          _buildSummaryTile(
                            context,
                            title: 'AI Recommendation',
                            value: 'Ready',
                            subtitle: '96.8% Match',
                            icon: Icons.psychology,
                            color: AppColors.secondaryDark,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      // Quick Action Navigation Grid
                      Text('Quick Actions', style: AppTypography.titleLarge),
                      const SizedBox(height: 12),

                      GridView.count(
                        crossAxisCount: 4,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        children: [
                          _buildQuickActionButton(
                            context,
                            label: 'Register Animal',
                            icon: Icons.add_circle_outline,
                            color: AppColors.primary,
                            onTap: () => context.push('/farmer/livestock/add'),
                          ),
                          _buildQuickActionButton(
                            context,
                            label: 'Medical Log',
                            icon: Icons.local_hospital_outlined,
                            color: AppColors.error,
                            onTap: () => context.push('/farmer/medical-vaccination'),
                          ),
                          _buildQuickActionButton(
                            context,
                            label: 'Feed & Climate',
                            icon: Icons.grass,
                            color: AppColors.success,
                            onTap: () => context.push('/farmer/feed-environmental'),
                          ),
                          _buildQuickActionButton(
                            context,
                            label: 'Document Vault',
                            icon: Icons.folder_open,
                            color: AppColors.secondaryDark,
                            onTap: () => context.push('/farmer/documents'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      // Monthly Expense Progress Cards
                      Text('Farm Operating Budgets', style: AppTypography.titleLarge),
                      const SizedBox(height: 12),
                      const ExpenseCardWidget(
                        title: 'Monthly Feed & Fodder Budget',
                        currentExpense: 5400,
                        maxBudget: 8000,
                        icon: Icons.grass,
                      ),
                      const SizedBox(height: 10),
                      const ExpenseCardWidget(
                        title: 'Veterinary & Medicine Expense',
                        currentExpense: 1200,
                        maxBudget: 3000,
                        icon: Icons.medication,
                      ),

                      const SizedBox(height: 24),
                      // Recent Livestock Inventory Preview
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('My Livestock Herd', style: AppTypography.titleLarge),
                          TextButton(
                            onPressed: () => context.push('/farmer/livestock'),
                            child: const Text('View All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      if (animals.isEmpty) ...[
                        const Center(child: Text('No livestock registered yet.')),
                      ] else ...[
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: animals.length > 3 ? 3 : animals.length,
                          itemBuilder: (context, index) {
                            final animal = animals[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: AnimalCardWidget(
                                animal: animal,
                                onTap: () => context.push('/farmer/livestock/${animal.id}'),
                              ),
                            );
                          },
                        ),
                      ],

                      const SizedBox(height: 24),
                      // Upcoming Vaccination Schedule Timeline
                      Text('Vaccination Schedule & Booster Alerts', style: AppTypography.titleLarge),
                      const SizedBox(height: 12),
                      VaccinationTimelineWidget(records: farmerState.vaccinationRecords),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherCard(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Map<String, dynamic>>(
      future: ref.read(weatherServiceProvider).getCurrentWeather(district: 'Coimbatore', state: 'Tamil Nadu'),
      builder: (context, snapshot) {
        final weather = snapshot.data ?? {
          "temperature_c": 35.5,
          "humidity_percent": 62.0,
          "heat_index_thi": 38.2,
          "climate_zone": "Semi-Arid Tropical",
          "forecast": "Clear sunny with evening light showers expected.",
        };

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
          ),
          child: Row(
            children: [
              const Icon(Icons.wb_sunny, color: AppColors.secondary, size: 42),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${weather["temperature_c"]}°C • ${weather["climate_zone"]}',
                          style: AppTypography.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'THI: ${weather["heat_index_thi"]}',
                          style: AppTypography.labelSmall.copyWith(color: AppColors.secondaryLight),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Humidity: ${weather["humidity_percent"]}% • ${weather["forecast"]}',
                      style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryTile(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: AppTypography.headlineMedium.copyWith(color: color, fontWeight: FontWeight.bold)),
                Text(title, style: AppTypography.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(subtitle, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(color: color, fontWeight: FontWeight.bold, fontSize: 10),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
