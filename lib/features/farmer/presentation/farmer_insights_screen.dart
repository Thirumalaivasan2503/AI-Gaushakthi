import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/cards/farmer_card.dart';
import '../../../core/widgets/cards/glass_card.dart';

/// Farmer Insights & Herd Performance Telemetry Screen
class FarmerInsightsScreen extends StatelessWidget {
  const FarmerInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Insights & Herd Telemetry'),
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.paddingMd,
          children: [
            const FarmerCard(
              farmerName: 'Ramesh Kumar',
              farmLocation: 'Coimbatore, Tamil Nadu',
              livestockCount: '8',
              primaryBreed: 'Gir & Kangayam',
            ),
            const SizedBox(height: 20),
            Text('Herd Health Summary', style: AppTypography.titleLarge),
            const SizedBox(height: 12),
            GlassCard(
              child: Column(
                children: [
                  _buildMetricRow('Active Cattle in Herd', '5 Lactating, 1 Draft Bull'),
                  const Divider(),
                  _buildMetricRow('Daily Milk Yield (A2)', '42 Litres / day'),
                  const Divider(),
                  _buildMetricRow('Natural Fodder Ratio', '85% Local Pasture Grazing'),
                  const Divider(),
                  _buildMetricRow('Vet Inspection Status', 'All Clear (Inspected July 24)'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Breed Performance Score', style: AppTypography.titleLarge),
            const SizedBox(height: 12),
            GlassCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCircularScore('Thermal', '98%', AppColors.primary),
                  _buildCircularScore('Immunity', '95%', AppColors.accent),
                  _buildCircularScore('Yield ROI', '92%', AppColors.secondaryDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall),
          Text(value, style: AppTypography.titleMedium),
        ],
      ),
    );
  }

  Widget _buildCircularScore(String label, String score, Color color) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Text(
            score,
            style: AppTypography.titleMedium.copyWith(color: color, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: AppTypography.labelSmall),
      ],
    );
  }
}
