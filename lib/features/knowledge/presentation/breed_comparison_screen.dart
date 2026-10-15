import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/cards/login_card.dart';
import '../domain/models/breed_info_model.dart';
import 'controllers/knowledge_controller.dart';

/// Side-by-Side Breed Comparison Matrix Screen
class BreedComparisonScreen extends ConsumerWidget {
  const BreedComparisonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(knowledgeControllerProvider);
    final selectedIds = state.comparisonSelectedBreedIds;
    final allBreeds = state.breeds;

    final selectedBreeds = allBreeds.where((b) => selectedIds.contains(b.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Breed Comparison Matrix'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Breeds to Compare (Max 3)', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              // Breed selection checkboxes
              Wrap(
                spacing: 8,
                children: allBreeds.map((b) {
                  final isSelected = selectedIds.contains(b.id);
                  return FilterChip(
                    label: Text(b.name),
                    selected: isSelected,
                    selectedColor: AppColors.secondary.withOpacity(0.3),
                    onSelected: (_) {
                      ref.read(knowledgeControllerProvider.notifier).toggleComparisonBreed(b.id);
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),
              if (selectedBreeds.isEmpty)
                const Center(child: Text('Select at least 1 breed to view comparison metrics.'))
              else ...[
                // Comparison Table Matrix
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 20,
                    headingRowColor: MaterialStateProperty.all(AppColors.primary.withOpacity(0.1)),
                    columns: [
                      const DataColumn(label: Text('Feature / Metric', style: TextStyle(fontWeight: FontWeight.bold))),
                      ...selectedBreeds.map((b) => DataColumn(label: Text(b.name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)))),
                    ],
                    rows: [
                      DataRow(cells: [
                        const DataCell(Text('Disease Immunity %')),
                        ...selectedBreeds.map((b) => DataCell(Text('${b.diseaseResistanceScore}%', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Milk Yield (L/year)')),
                        ...selectedBreeds.map((b) => DataCell(Text(b.milkProductionLiters))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Climate Adaptability')),
                        ...selectedBreeds.map((b) => DataCell(Text(b.climateSuitability))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Daily Maintenance Cost')),
                        ...selectedBreeds.map((b) => DataCell(Text(b.maintenanceCost))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Body Weight')),
                        ...selectedBreeds.map((b) => DataCell(Text(b.bodyWeightKg))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Lifespan')),
                        ...selectedBreeds.map((b) => DataCell(Text(b.lifespanYears))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Govt Recognition')),
                        ...selectedBreeds.map((b) => DataCell(Text(b.conservationStatus))),
                      ]),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                // Economic Comparison Summary Card
                LoginCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.analytics_outlined, color: AppColors.secondary),
                          const SizedBox(width: 8),
                          Text('Economic & Sustainability Summary', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...selectedBreeds.map((b) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '• ${b.name}: ${b.economicValue}',
                            style: AppTypography.bodySmall,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
