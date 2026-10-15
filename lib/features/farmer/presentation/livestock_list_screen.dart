import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/cards/animal_card.dart';
import '../../../core/widgets/feedback/loading_overlay.dart';
import '../../../core/widgets/input/custom_dropdown.dart';
import '../../../core/widgets/input/search_bar_widget.dart';
import '../domain/models/livestock_model.dart';
import 'controllers/farmer_controller.dart';

/// Livestock Listing Screen with Search, Multi-Filter & Sorting
class LivestockListScreen extends ConsumerStatefulWidget {
  const LivestockListScreen({super.key});

  @override
  ConsumerState<LivestockListScreen> createState() => _LivestockListScreenState();
}

class _LivestockListScreenState extends ConsumerState<LivestockListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final farmerState = ref.watch(farmerControllerProvider);
    final animals = farmerState.filteredLivestockList;

    return Scaffold(
      appBar: AppBar(
        title: Text('Registered Livestock (${animals.length})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(farmerControllerProvider.notifier).loadAllFarmerData();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/farmer/livestock/add'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Add Animal', style: AppTypography.labelMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: LoadingOverlay(
        isLoading: farmerState.isLoading,
        message: 'Filtering livestock inventory...',
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.paddingMd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                SearchBarWidget(
                  hintText: 'Search by ear tag, breed, or animal name...',
                  onChanged: (val) {
                    ref.read(farmerControllerProvider.notifier).searchLivestock(val);
                  },
                ),
                const SizedBox(height: 12),

                // Filter & Sort Row
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Breed Filter Chip
                            FilterChip(
                              label: Text(farmerState.selectedBreedFilter ?? 'All Breeds'),
                              selected: farmerState.selectedBreedFilter != null,
                              selectedColor: AppColors.primary.withOpacity(0.2),
                              onSelected: (_) {
                                _showBreedFilterDialog(context, ref);
                              },
                            ),
                            const SizedBox(width: 8),
                            // Health Status Filter Chip
                            FilterChip(
                              label: Text(farmerState.selectedHealthFilter?.label ?? 'All Health Statuses'),
                              selected: farmerState.selectedHealthFilter != null,
                              selectedColor: AppColors.secondary.withOpacity(0.3),
                              onSelected: (_) {
                                _showHealthFilterDialog(context, ref);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Sort Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: farmerState.sortBy,
                          icon: const Icon(Icons.sort, size: 18, color: AppColors.primary),
                          style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
                          onChanged: (val) {
                            if (val != null) {
                              ref.read(farmerControllerProvider.notifier).setSortBy(val);
                            }
                          },
                          items: const [
                            DropdownMenuItem(value: 'recent', child: Text('Sort: Recent')),
                            DropdownMenuItem(value: 'age', child: Text('Sort: Age')),
                            DropdownMenuItem(value: 'productivity', child: Text('Sort: Weight')),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Animal List View
                Expanded(
                  child: animals.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.pets_outlined, size: 54, color: AppColors.textMuted),
                              const SizedBox(height: 16),
                              Text('No animals match your filters', style: AppTypography.titleMedium),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  ref.read(farmerControllerProvider.notifier).searchLivestock('');
                                  ref.read(farmerControllerProvider.notifier).filterByBreed(null);
                                  ref.read(farmerControllerProvider.notifier).filterByHealthStatus(null);
                                },
                                child: const Text('Clear All Filters'),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: animals.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final animal = animals[index];
                            return AnimalCardWidget(
                              animal: animal,
                              onTap: () => context.push('/farmer/livestock/${animal.id}'),
                            );
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

  void _showBreedFilterDialog(BuildContext context, WidgetRef ref) {
    const breeds = ['All Breeds', 'Kangayam Cattle', 'Sahiwal Cow', 'Bargur Cattle', 'Tellicherry Goat'];
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Filter by Breed'),
        children: breeds.map((b) {
          return SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              if (b == 'All Breeds') {
                ref.read(farmerControllerProvider.notifier).filterByBreed(null);
              } else {
                ref.read(farmerControllerProvider.notifier).filterByBreed(b);
              }
            },
            child: Text(b, style: AppTypography.bodyMedium),
          );
        }).toList(),
      ),
    );
  }

  void _showHealthFilterDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Filter by Health Status'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              ref.read(farmerControllerProvider.notifier).filterByHealthStatus(null);
            },
            child: const Text('All Health Statuses'),
          ),
          ...LivestockHealthStatus.values.map((status) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                ref.read(farmerControllerProvider.notifier).filterByHealthStatus(status);
              },
              child: Text(status.label, style: AppTypography.bodyMedium),
            );
          }).toList(),
        ],
      ),
    );
  }
}
