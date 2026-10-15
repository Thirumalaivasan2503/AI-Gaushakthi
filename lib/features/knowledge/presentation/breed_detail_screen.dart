import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/cards/login_card.dart';
import '../domain/models/breed_info_model.dart';
import 'controllers/knowledge_controller.dart';

/// Detailed Breed Profile Screen
class BreedDetailScreen extends ConsumerWidget {
  final String breedId;

  const BreedDetailScreen({
    super.key,
    required this.breedId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(knowledgeControllerProvider);
    BreedInfoModel? breed;

    try {
      breed = state.breeds.firstWhere((b) => b.id == breedId || b.name.toLowerCase().contains(breedId.toLowerCase()));
    } catch (_) {
      breed = null;
    }

    if (breed == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Breed Profile')),
        body: const Center(child: Text('Breed profile details not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(breed.name),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Gold Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: AppSpacing.borderRadiusLg,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.primary,
                      child: Icon(
                        breed.species.contains('Goat') ? Icons.pets : Icons.agriculture,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(breed.name, style: AppTypography.headlineMedium.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
                          Text(breed.species, style: AppTypography.titleSmall.copyWith(color: AppColors.primaryDark)),
                          const SizedBox(height: 4),
                          Text('Status: ${breed.conservationStatus}', style: AppTypography.labelSmall.copyWith(color: AppColors.primaryDark)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Disease Immunity & Milk Bar
              LoginCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Disease Immunity Score', style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold)),
                        Text('${breed.diseaseResistanceScore}%', style: AppTypography.titleMedium.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: breed.diseaseResistanceScore / 100.0,
                      backgroundColor: AppColors.border,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                    ),
                    const SizedBox(height: 12),
                    Text('Milk Production: ${breed.milkProductionLiters}', style: AppTypography.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    Text('Body Weight: ${breed.bodyWeightKg}', style: AppTypography.bodySmall),
                    Text('Lifespan: ${breed.lifespanYears}', style: AppTypography.bodySmall),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // Climate & Recommended Farming Conditions
              Text('Climate Suitability & Agro-Zone', style: AppTypography.titleLarge),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.0,
                children: [
                  _buildMiniInfoBox(context, 'Temperature', breed.recommendedTempRange, Icons.thermostat),
                  _buildMiniInfoBox(context, 'Rainfall', breed.rainfallRangeMm, Icons.water_drop),
                  _buildMiniInfoBox(context, 'Water Req', breed.waterRequirement, Icons.local_drink),
                  _buildMiniInfoBox(context, 'Daily Feed Cost', breed.maintenanceCost, Icons.payments),
                ],
              ),

              const SizedBox(height: 24),
              // Origin, History & Economic Advantages
              Text('Origin & Breed History', style: AppTypography.titleLarge),
              const SizedBox(height: 8),
              Text(breed.history, style: AppTypography.bodyMedium),
              const SizedBox(height: 16),

              Text('Key Advantages', style: AppTypography.titleLarge),
              const SizedBox(height: 8),
              Column(
                children: breed.advantages.map((adv) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(adv, style: AppTypography.bodySmall)),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),
              // Government Recognition Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified, color: AppColors.primary, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Govt Recognition: ${breed.governmentRecognition}',
                        style: AppTypography.labelSmall.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                      ),
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

  Widget _buildMiniInfoBox(BuildContext context, String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
