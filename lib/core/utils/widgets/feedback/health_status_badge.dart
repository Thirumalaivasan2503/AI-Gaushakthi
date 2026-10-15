import 'package:flutter/material.dart';
import '../../../features/farmer/domain/models/livestock_model.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';

/// Color-coded Health Status Badge Chip
class HealthStatusBadgeWidget extends StatelessWidget {
  final LivestockHealthStatus status;

  const HealthStatusBadgeWidget({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final colorConfig = _getColors(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colorConfig.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorConfig.fg.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 4, backgroundColor: colorConfig.fg),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: AppTypography.labelSmall.copyWith(
              color: colorConfig.fg,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  ({Color bg, Color fg}) _getColors(LivestockHealthStatus status) {
    switch (status) {
      case LivestockHealthStatus.healthy:
        return (bg: AppColors.success.withOpacity(0.12), fg: AppColors.success);
      case LivestockHealthStatus.underTreatment:
        return (bg: AppColors.error.withOpacity(0.12), fg: AppColors.error);
      case LivestockHealthStatus.pregnant:
        return (bg: Colors.purple.withOpacity(0.12), fg: Colors.purple);
      case LivestockHealthStatus.lactating:
        return (bg: AppColors.info.withOpacity(0.12), fg: AppColors.info);
      case LivestockHealthStatus.sold:
        return (bg: Colors.grey.withOpacity(0.12), fg: Colors.grey);
    }
  }
}
