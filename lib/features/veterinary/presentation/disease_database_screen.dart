import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/cards/login_card.dart';
import '../../../core/widgets/feedback/loading_overlay.dart';
import '../../../core/widgets/input/search_bar_widget.dart';
import '../domain/models/disease_model.dart';
import 'controllers/vet_controller.dart';

/// Clinical Disease Database & Advisory Screen
class DiseaseDatabaseScreen extends ConsumerWidget {
  const DiseaseDatabaseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vetState = ref.watch(vetControllerProvider);
    final diseases = vetState.filteredDiseases;

    return Scaffold(
      appBar: AppBar(
        title: Text('Disease Database (${diseases.length})'),
      ),
      body: LoadingOverlay(
        isLoading: vetState.isLoading,
        message: 'Filtering disease database...',
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.paddingMd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                SearchBarWidget(
                  hintText: 'Search FMD, Lumpy Skin, symptoms, or virus...',
                  onChanged: (val) {
                    ref.read(vetControllerProvider.notifier).searchDiseases(val);
                  },
                ),
                const SizedBox(height: 12),

                // Severity Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('All Severities'),
                        selected: vetState.selectedSeverityFilter == null,
                        onSelected: (_) => ref.read(vetControllerProvider.notifier).filterDiseaseSeverity(null),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Emergency / Critical'),
                        selected: vetState.selectedSeverityFilter == 'Critical',
                        selectedColor: AppColors.error.withOpacity(0.2),
                        onSelected: (_) => ref.read(vetControllerProvider.notifier).filterDiseaseSeverity('Critical'),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('High Severity'),
                        selected: vetState.selectedSeverityFilter == 'High',
                        selectedColor: AppColors.warning.withOpacity(0.2),
                        onSelected: (_) => ref.read(vetControllerProvider.notifier).filterDiseaseSeverity('High'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Disease List
                Expanded(
                  child: diseases.isEmpty
                      ? const Center(child: Text('No diseases match your search criteria.'))
                      : ListView.separated(
                          itemCount: diseases.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final d = diseases[index];
                            return _buildDiseaseCard(context, ref, d);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiseaseCard(BuildContext context, WidgetRef ref, DiseaseModel disease) {
    return LoginCard(
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        leading: Icon(
          disease.isEmergency ? Icons.error : Icons.medical_information_outlined,
          color: disease.isEmergency ? AppColors.error : AppColors.primary,
          size: 28,
        ),
        title: Text(disease.name, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text('Severity: ${disease.severity} • Recovery: ${disease.recoveryPeriod}', style: AppTypography.bodySmall),
        trailing: IconButton(
          icon: Icon(
            disease.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: AppColors.secondary,
          ),
          onPressed: () {
            ref.read(vetControllerProvider.notifier).toggleBookmarkDisease(disease.id);
          },
        ),
        children: [
          const Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Key Symptoms:', style: AppTypography.titleSmall),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                children: disease.symptoms.map((s) {
                  return Chip(
                    label: Text(s, style: AppTypography.labelSmall),
                    backgroundColor: AppColors.primary.withOpacity(0.08),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Text('Treatment Protocol:', style: AppTypography.titleSmall),
              Text(disease.treatment, style: AppTypography.bodySmall),
              const SizedBox(height: 6),
              Text('Medicines: ${disease.medicine}', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.warning),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.campaign, color: AppColors.warning, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Govt Advisory: ${disease.governmentAdvisory}',
                        style: AppTypography.labelSmall.copyWith(color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
