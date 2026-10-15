import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/cards/glass_card.dart';
import '../../../core/widgets/cards/login_card.dart';

/// AI Recommendation Dashboard with Analytics, Climate Analysis & ROI Projections
class AIDashboardScreen extends ConsumerWidget {
  const AIDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Analytics Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/recommendation-history'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Agronomic Analytics & Prediction Hub', style: AppTypography.displayMedium.copyWith(color: AppColors.primary)),
              const SizedBox(height: 6),
              Text('Real-time ML metrics, climate adaptation scores, and ROI profit projections.', style: AppTypography.bodyMedium),
              const SizedBox(height: 20),

              // Glassmorphic Sustainability & Confidence Banner
              GlassCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ML Model Accuracy', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                            Text('79.33%', style: AppTypography.headlineMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                            Text('5-Fold Cross Validated', style: AppTypography.labelSmall.copyWith(color: AppColors.success)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Sustainability Index', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                            Text('98.5 / 100', style: AppTypography.headlineMedium.copyWith(color: AppColors.secondaryDark, fontWeight: FontWeight.bold)),
                            Text('Eco-Friendly Native Breed', style: AppTypography.labelSmall.copyWith(color: AppColors.secondary)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Analytics Metric Cards Grid
              Text('Breed Suitability Breakdown', style: AppTypography.titleLarge),
              const SizedBox(height: 12),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _buildMetricTile(context, 'Climate Score', '99.0%', 'Resilient to 48°C', Icons.thermostat, AppColors.error),
                  _buildMetricTile(context, 'Disease Immunity', '98.5%', 'FMD & Tick Immune', Icons.shield, AppColors.success),
                  _buildMetricTile(context, 'Profit Projection', '+₹35,000/yr', 'Diesel Draft Saved', Icons.trending_up, AppColors.primary),
                  _buildMetricTile(context, 'Feed Maintenance', '₹120 / Day', 'Low Roughage Cost', Icons.grass, AppColors.warning),
                ],
              ),

              const SizedBox(height: 24),
              // ROI Profit Projection Graph Simulation
              LoginCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.show_chart, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text('5-Year Projected Farmer Income (₹ Lakhs)', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBarColumn('Yr 1', 0.3, '₹1.2L'),
                        _buildBarColumn('Yr 2', 0.5, '₹2.1L'),
                        _buildBarColumn('Yr 3', 0.7, '₹3.4L'),
                        _buildBarColumn('Yr 4', 0.85, '₹4.2L'),
                        _buildBarColumn('Yr 5', 1.0, '₹5.5L'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Action Button to details
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => context.push('/prediction-details'),
                icon: const Icon(Icons.insights, color: Colors.white),
                label: const Text('View Deep Prediction & XAI Rationales', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile(BuildContext context, String title, String value, String sub, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 6),
              Expanded(child: Text(title, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted), maxLines: 1)),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: AppTypography.titleLarge.copyWith(color: color, fontWeight: FontWeight.bold)),
          Text(sub, style: AppTypography.labelSmall),
        ],
      ),
    );
  }

  Widget _buildBarColumn(String label, double heightFactor, String amount) {
    return Column(
      children: [
        Text(amount, style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          width: 32,
          height: 120 * heightFactor,
          decoration: BoxDecoration(
            gradient: AppColors.goldGradient,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: AppTypography.labelSmall),
      ],
    );
  }
}
