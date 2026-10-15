import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';
import 'glass_card.dart';

/// Detailed Breed Showcase Card Widget
class BreedCard extends StatelessWidget {
  final String breedName;
  final String originState;
  final String characteristics;
  final String diseaseResistanceLevel;

  const BreedCard({
    super.key,
    required this.breedName,
    required this.originState,
    required this.characteristics,
    required this.diseaseResistanceLevel,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(breedName, style: AppTypography.titleLarge),
              Chip(
                label: Text(originState, style: AppTypography.labelSmall),
                backgroundColor: AppColors.secondary.withOpacity(0.2),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(characteristics, style: AppTypography.bodySmall),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.shield, size: 16, color: AppColors.success),
              const SizedBox(width: 6),
              Text(
                'Disease Resistance: $diseaseResistanceLevel',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.success,
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
