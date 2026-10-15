import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';
import 'glass_card.dart';

/// Analytics & KPI Metric Graphic Card Widget
class AnalyticsCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtext;
  final IconData icon;
  final Color accentColor;

  const AnalyticsCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtext,
    required this.icon,
    this.accentColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodySmall),
                const SizedBox(height: 2),
                Text(value, style: AppTypography.headlineMedium),
                const SizedBox(height: 2),
                Text(
                  subtext,
                  style: AppTypography.labelSmall.copyWith(color: AppColors.success),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
