import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';
import 'glass_card.dart';

/// Farmer Profile & Farm Operations Summary Card
class FarmerCard extends StatelessWidget {
  final String farmerName;
  final String farmLocation;
  final String livestockCount;
  final String primaryBreed;

  const FarmerCard({
    super.key,
    required this.farmerName,
    required this.farmLocation,
    required this.livestockCount,
    required this.primaryBreed,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withOpacity(0.2),
            child: const Icon(Icons.person, color: AppColors.primary, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(farmerName, style: AppTypography.titleLarge),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(farmLocation, style: AppTypography.bodySmall),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '$livestockCount Animals • $primaryBreed',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.secondaryDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
