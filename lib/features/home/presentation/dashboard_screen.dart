import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/cards/glass_card.dart';
import '../../../core/widgets/cards/recommendation_card.dart';
import '../../../core/widgets/cards/analytics_card.dart';
import '../../../core/widgets/cards/statistics_card.dart';
import '../../../core/widgets/feedback/offline_banner.dart';

/// Commercial-Quality AgriTech Dashboard Screen
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 800));
          },
          child: SingleChildScrollView(
            padding: AppSpacing.paddingMd,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              'Coimbatore, Tamil Nadu',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text('Vanakkam, Ramesh!', style: AppTypography.headlineLarge),
                      ],
                    ),
                    InkWell(
                      onTap: () => context.push('/profile'),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.secondary, width: 2),
                        ),
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primary,
                          child: Icon(Icons.person, color: Colors.white, size: 22),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const OfflineBanner(),

                const SizedBox(height: 20),
                // AI Recommendation Spotlight Banner
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('AI Breed Spotlight', style: AppTypography.titleLarge),
                    TextButton(
                      onPressed: () => context.go('/recommendation'),
                      child: Text('View All (12)', style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                RecommendationCard(
                  breedName: 'Kangayam Cattle',
                  species: 'Cow (BOS INDICUS)',
                  suitabilityPercentage: '96.8',
                  milkYieldOrPurpose: 'Draft & Milk (700 L/yr)',
                  heatToleranceRating: '48°C Resistance',
                  diseaseResistanceScore: 'High (FMD Immune)',
                  isOfflineCached: true,
                  onTap: () => context.go('/recommendation'),
                ),

                const SizedBox(height: 24),
                // Quick Action Grid Icons
                Text('Quick Agri-Tools', style: AppTypography.titleLarge),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionTile(
                        context: context,
                        title: 'Farmer Insights',
                        icon: Icons.agriculture,
                        color: AppColors.primary,
                        onTap: () => context.push('/farmer-insights'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionTile(
                        context: context,
                        title: 'Vet Consult',
                        icon: Icons.health_and_safety,
                        color: AppColors.accent,
                        onTap: () => context.push('/vet-telemetry'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionTile(
                        context: context,
                        title: 'Economic ROI',
                        icon: Icons.analytics,
                        color: AppColors.secondaryDark,
                        onTap: () => context.push('/economic-analysis'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                // Weather & Agro-Climate Glass Card
                GlassCard(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.info.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.wb_sunny, color: AppColors.secondaryDark, size: 30),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Agro-Climate Index', style: AppTypography.labelSmall),
                            Text('Semi-Arid • 34°C (THI: 72)', style: AppTypography.titleMedium),
                            Text('Optimal conditions for native zebu cattle grazing.', style: AppTypography.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                // Analytics & Performance Summary
                Row(
                  children: const [
                    Expanded(
                      child: StatisticsCard(
                        label: 'Fodder Efficiency',
                        amountOrPercent: '+24%',
                        growthTrend: 'Low Feed Cost',
                        isPositiveTrend: true,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: StatisticsCard(
                        label: 'Disease Immunity',
                        amountOrPercent: '98%',
                        growthTrend: 'High Resistance',
                        isPositiveTrend: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                // Vaccination Reminder Card
                Text('Care & Vaccination Reminder', style: AppTypography.titleLarge),
                const SizedBox(height: 12),
                AnalyticsCard(
                  title: 'Upcoming Vaccination',
                  value: 'FMD Booster Dose',
                  subtext: 'Scheduled for 3 Sahiwal & 2 Kangayam cows on Aug 15',
                  icon: Icons.vaccines,
                  accentColor: AppColors.warning,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
