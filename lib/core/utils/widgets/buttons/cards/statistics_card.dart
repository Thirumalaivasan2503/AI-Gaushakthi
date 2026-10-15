import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';
import 'glass_card.dart';

/// Financial & Statistics KPI Card Widget
class StatisticsCard extends StatelessWidget {
  final String label;
  final String amountOrPercent;
  final String growthTrend;
  final bool isPositiveTrend;

  const StatisticsCard({
    super.key,
    required this.label,
    required this.amountOrPercent,
    required this.growthTrend,
    this.isPositiveTrend = true,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.labelSmall),
          const SizedBox(height: 6),
          Text(amountOrPercent, style: AppTypography.displayMedium),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                isPositiveTrend ? Icons.arrow_upward : Icons.arrow_downward,
                size: 14,
                color: isPositiveTrend ? AppColors.success : AppColors.error,
              ),
              const SizedBox(width: 4),
              Text(
                growthTrend,
                style: AppTypography.labelSmall.copyWith(
                  color: isPositiveTrend ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
