import 'package:flutter/material.dart';
import '../../../features/farmer/domain/models/livestock_model.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_typography.dart';
import '../feedback/health_status_badge.dart';

/// Reusable Animal List Card Component
class AnimalCardWidget extends StatelessWidget {
  final LivestockModel animal;
  final VoidCallback onTap;
  final VoidCallback? onEditTap;

  const AnimalCardWidget({
    super.key,
    required this.animal,
    required this.onTap,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusMd,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Animal Avatar
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.secondary.withOpacity(0.4)),
              ),
              child: Icon(
                animal.species == LivestockSpecies.goat
                    ? Icons.pets
                    : Icons.agriculture,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(width: 14),

            // Info Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        animal.name,
                        style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                      ),
                      HealthStatusBadgeWidget(status: animal.healthStatus),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${animal.breed} • ${animal.earTagNumber}',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildMetricChip(Icons.cake_outlined, '${animal.ageYears} yrs'),
                      const SizedBox(width: 12),
                      _buildMetricChip(Icons.monitor_weight_outlined, '${animal.weightKg} kg'),
                      const SizedBox(width: 12),
                      _buildMetricChip(Icons.straighten, '${animal.heightCm} cm'),
                    ],
                  ),
                ],
              ),
            ),

            if (onEditTap != null)
              IconButton(
                icon: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                onPressed: onTap,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 3),
        Text(label, style: AppTypography.labelSmall),
      ],
    );
  }
}
