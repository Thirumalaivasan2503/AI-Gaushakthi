import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';
import 'glass_card.dart';
import '../navigation/offline_badge.dart';

/// AI Indigenous Breed Recommendation Showcase Card Widget
class RecommendationCard extends StatelessWidget {
  final String breedName;
  final String species;
  final String suitabilityPercentage;
  final String milkYieldOrPurpose;
  final String heatToleranceRating;
  final String diseaseResistanceScore;
  final bool isOfflineCached;
  final VoidCallback? onTap;

  const RecommendationCard({
    super.key,
    required this.breedName,
    required this.species,
    required this.suitabilityPercentage,
    required this.milkYieldOrPurpose,
    required this.heatToleranceRating,
    required this.diseaseResistanceScore,
    this.isOfflineCached = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      species.toUpperCase(),
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (isOfflineCached) ...[
                    const SizedBox(width: 8),
                    const OfflineBadge(),
                  ],
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, size: 14, color: AppColors.textPrimary),
                    const SizedBox(width: 4),
                    Text(
                      '$suitabilityPercentage% Match',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            breedName,
            style: AppTypography.headlineMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Optimal for semi-arid agro-climatic zones & natural grazing.',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricChip(Icons.water_drop, 'Yield', milkYieldOrPurpose),
              _buildMetricChip(Icons.thermostat, 'Thermal', heatToleranceRating),
              _buildMetricChip(Icons.verified_user, 'Immunity', diseaseResistanceScore),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChip(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(label, style: AppTypography.labelSmall),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
