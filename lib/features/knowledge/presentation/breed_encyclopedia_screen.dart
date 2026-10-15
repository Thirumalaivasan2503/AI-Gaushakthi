import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/cards/login_card.dart';
import '../../../core/widgets/feedback/loading_overlay.dart';
import '../../../core/widgets/input/search_bar_widget.dart';
import '../domain/models/breed_info_model.dart';
import 'controllers/knowledge_controller.dart';

/// Breed Encyclopedia Listing Screen
class BreedEncyclopediaScreen extends ConsumerWidget {
  const BreedEncyclopediaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(knowledgeControllerProvider);
    final breeds = state.filteredBreeds;

    return Scaffold(
      appBar: AppBar(
        title: Text('Breed Encyclopedia (${breeds.length})'),
      ),
      body: LoadingOverlay(
        isLoading: state.isLoading,
        message: 'Searching encyclopedia...',
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.paddingMd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchBarWidget(
                  hintText: 'Search breed name, origin, or climate...',
                  onChanged: (val) {
                    ref.read(knowledgeControllerProvider.notifier).search(val);
                  },
                ),
                const SizedBox(height: 12),

                // Species Filter Chips
                Row(
                  children: [
                    FilterChip(
                      label: const Text('All Breeds'),
                      selected: state.selectedSpeciesFilter == null,
                      onSelected: (_) => ref.read(knowledgeControllerProvider.notifier).filterSpecies(null),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Cattle (Bos indicus)'),
                      selected: state.selectedSpeciesFilter == 'Cattle',
                      onSelected: (_) => ref.read(knowledgeControllerProvider.notifier).filterSpecies('Cattle'),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Goat Breeds'),
                      selected: state.selectedSpeciesFilter == 'Goat',
                      onSelected: (_) => ref.read(knowledgeControllerProvider.notifier).filterSpecies('Goat'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: breeds.isEmpty
                      ? const Center(child: Text('No breeds found matching your query.'))
                      : ListView.separated(
                          itemCount: breeds.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final breed = breeds[index];
                            return _buildBreedTile(context, breed);
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

  Widget _buildBreedTile(BuildContext context, BreedInfoModel breed) {
    return LoginCard(
      child: InkWell(
        onTap: () {
          context.push('/knowledge/breeds/${breed.id}');
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.primary.withOpacity(0.12),
              child: Icon(
                breed.species.contains('Goat') ? Icons.pets : Icons.agriculture,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(breed.name, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('${breed.diseaseResistanceScore}% Immunity', style: AppTypography.labelSmall.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Origin: ${breed.origin}', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                  Text('Milk Yield: ${breed.milkProductionLiters}', style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
