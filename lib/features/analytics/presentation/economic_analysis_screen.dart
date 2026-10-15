import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/cards/glass_card.dart';
import '../../../core/widgets/cards/login_card.dart';

/// Advanced System Analytics & Economic ROI Projections Screen
class EconomicAnalysisScreen extends ConsumerWidget {
  const EconomicAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System & Economic Analytics'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('System Performance & Agronomic Insights', style: AppTypography.displayMedium.copyWith(color: AppColors.primary)),
              const SizedBox(height: 6),
              Text('Detailed ML accuracy trends, breed popularity, disease outbreak prevention, and economic ROI metrics.', style: AppTypography.bodyMedium),
              const SizedBox(height: 20),

              // KPI Header Cards
              GlassCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildKpiItem('Prediction Accuracy', '79.33%', AppColors.primary),
                    _buildKpiItem('Farmers Onboarded', '1,420', AppColors.secondaryDark),
                    _buildKpiItem('Disease Prevention', '38 Outbreaks', AppColors.success),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Breed Popularity Breakdown Chart
              Text('Indigenous Breed Popularity Matrix', style: AppTypography.titleLarge),
              const SizedBox(height: 12),

              LoginCard(
                child: Column(
                  children: [
                    _buildPopularityBar('Kangayam Cattle', 0.42, '42% Matches'),
                    _buildPopularityBar('Sahiwal Cow', 0.28, '28% Matches'),
                    _buildPopularityBar('Gir Cow', 0.18, '18% Matches'),
                    _buildPopularityBar('Tellicherry Goat', 0.12, '12% Matches'),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Economic Net Income Projection (5 Years)
              Text('5-Year Agronomic Income Projection', style: AppTypography.titleLarge),
              const SizedBox(height: 12),

              LoginCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Net Cumulative Profit per Farmer (₹ Lakhs)', style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBarColumn('2024', 0.35, '₹1.4L'),
                        _buildBarColumn('2025', 0.55, '₹2.3L'),
                        _buildBarColumn('2026', 0.75, '₹3.6L'),
                        _buildBarColumn('2027', 0.90, '₹4.8L'),
                        _buildBarColumn('2028', 1.00, '₹5.8L'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(value, style: AppTypography.headlineMedium.copyWith(color: color, fontWeight: FontWeight.bold)),
        Text(title, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
      ],
    );
  }

  Widget _buildPopularityBar(String label, double pct, String pctText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold)),
              Text(pctText, style: AppTypography.labelSmall),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: pct,
            backgroundColor: AppColors.border,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
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
