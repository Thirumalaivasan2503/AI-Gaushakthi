import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/cards/login_card.dart';
import '../../../core/widgets/feedback/health_status_badge.dart';
import '../../../core/widgets/feedback/vaccination_timeline.dart';
import '../domain/models/livestock_model.dart';
import 'controllers/farmer_controller.dart';

/// Comprehensive Animal Profile Detail Screen
class LivestockDetailScreen extends ConsumerWidget {
  final String animalId;

  const LivestockDetailScreen({
    super.key,
    required this.animalId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmerState = ref.watch(farmerControllerProvider);
    final animals = farmerState.livestockList;
    LivestockModel? animal;

    try {
      animal = animals.firstWhere((a) => a.id == animalId || a.animalId == animalId);
    } catch (_) {
      animal = null;
    }

    if (animal == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Animal Details')),
        body: const Center(child: Text('Livestock profile not found.')),
      );
    }

    final animalVaccines = farmerState.vaccinationRecords.where((v) => v.livestockId == animal!.id).toList();
    final animalMedicals = farmerState.medicalRecords.where((m) => m.livestockId == animal!.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(animal.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              context.push('/farmer/livestock/add', extra: animal!.id);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () => _confirmDelete(context, ref, animal!.id),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
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
                        animal.species == LivestockSpecies.goat ? Icons.pets : Icons.agriculture,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                animal.name,
                                style: AppTypography.headlineMedium.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                              ),
                              HealthStatusBadgeWidget(status: animal.healthStatus),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Breed: ${animal.breed}',
                            style: AppTypography.titleSmall.copyWith(color: AppColors.primaryDark),
                          ),
                          Text(
                            'Ear Tag: ${animal.earTagNumber} (${animal.animalId})',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.primaryDark.withOpacity(0.8)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Physical Attributes Grid
              Text('Physical Attributes & Metrics', style: AppTypography.titleLarge),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildMetricBox(context, 'Age', '${animal.ageYears} Yrs', Icons.cake_outlined),
                  _buildMetricBox(context, 'Weight', '${animal.weightKg} kg', Icons.monitor_weight_outlined),
                  _buildMetricBox(context, 'Height', '${animal.heightCm} cm', Icons.straighten),
                  _buildMetricBox(context, 'Gender', animal.gender, Icons.wc),
                  _buildMetricBox(context, 'Color', animal.color, Icons.palette_outlined),
                  _buildMetricBox(context, 'Cost', '₹${animal.purchaseCost.toStringAsFixed(0)}', Icons.payments_outlined),
                ],
              ),

              const SizedBox(height: 28),
              // Medical History Log
              Text('Medical History & Treatment Log', style: AppTypography.titleLarge),
              const SizedBox(height: 12),
              if (animalMedicals.isEmpty) ...[
                LoginCard(
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, color: AppColors.success, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'No medical complications or active treatments recorded for this animal.',
                          style: AppTypography.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Column(
                  children: animalMedicals.map((m) {
                    return LoginCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(m.diseaseName, style: AppTypography.titleMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                              Text(m.diagnosisDate, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text('Medicines: ${m.medicinesPrescribed}', style: AppTypography.bodySmall),
                          Text('Doctor: ${m.veterinaryDoctorName}', style: AppTypography.bodySmall),
                          Text('Status: ${m.recoveryStatus}', style: AppTypography.labelSmall.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 28),
              // Vaccination Timeline
              Text('Vaccination Schedule', style: AppTypography.titleLarge),
              const SizedBox(height: 12),
              VaccinationTimelineWidget(records: animalVaccines),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricBox(BuildContext context, String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 6),
          Text(value, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Livestock Entry'),
        content: const Text('Are you sure you want to delete this animal from your farm inventory?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(farmerControllerProvider.notifier).deleteAnimal(id);
              if (context.mounted) {
                context.pop();
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
