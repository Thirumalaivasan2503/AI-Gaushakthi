import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/cards/glass_card.dart';
import '../../../core/widgets/cards/login_card.dart';

/// Admin AI Engine Analytics & Telemetry Dashboard Screen
class AdminAIAnalyticsScreen extends ConsumerWidget {
  const AdminAIAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin AI Telemetry & Health'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('LLM & ML System Health', style: AppTypography.displayMedium.copyWith(color: AppColors.primary)),
              const SizedBox(height: 6),
              Text('Track active LLM provider, token consumption, prediction confidence, and regional adoption.', style: AppTypography.bodyMedium),
              const SizedBox(height: 20),

              // LLM Status Banner
              GlassCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Active LLM Provider', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                            Text('Gemini 2.5 Flash', style: AppTypography.titleLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                            Text('Fallback: GPT-4o / Claude 3.5', style: AppTypography.labelSmall.copyWith(color: AppColors.secondary)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Tokens Processed', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                            Text('482.4 K', style: AppTypography.titleLarge.copyWith(color: AppColors.secondaryDark, fontWeight: FontWeight.bold)),
                            Text('Avg Response: 420ms', style: AppTypography.labelSmall.copyWith(color: AppColors.success)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Model Confidence Distribution Matrix
              Text('Prediction Confidence Distribution', style: AppTypography.titleLarge),
              const SizedBox(height: 12),

              LoginCard(
                child: Column(
                  children: [
                    _buildDistRow('> 95% High Match', 0.68, '68% Predictions'),
                    _buildDistRow('90% - 95% Moderate Match', 0.24, '24% Predictions'),
                    _buildDistRow('< 90% Needs Refinement', 0.08, '8% Predictions'),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Regional Adoption
              Text('Regional Farmer Adoption', style: AppTypography.titleLarge),
              const SizedBox(height: 12),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: [
                  _buildRegionCard('Tamil Nadu', '842 Farmers', 'Kangayam Preferred'),
                  _buildRegionCard('Gujarat', '310 Farmers', 'Gir Preferred'),
                  _buildRegionCard('Punjab', '180 Farmers', 'Sahiwal Preferred'),
                  _buildRegionCard('Andhra Pradesh', '88 Farmers', 'Ongole Preferred'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDistRow(String label, double pct, String countText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold)),
              Text(countText, style: AppTypography.labelSmall),
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

  Widget _buildRegionCard(String region, String farmers, String pref) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(region, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
          Text(farmers, style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.bold)),
          Text(pref, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
