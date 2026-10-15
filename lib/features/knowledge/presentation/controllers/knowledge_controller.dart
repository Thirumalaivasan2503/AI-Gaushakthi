import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/api_service.dart';
import '../../data/repositories/knowledge_repository_impl.dart';
import '../../domain/models/breed_info_model.dart';
import '../../domain/models/knowledge_article_model.dart';
import '../../domain/repositories/knowledge_repository.dart';

final knowledgeRepositoryProvider = Provider<KnowledgeRepository>((ref) {
  return KnowledgeRepositoryImpl(apiService: ref.watch(apiServiceProvider));
});

class KnowledgeState extends Equatable {
  final List<BreedInfoModel> breeds;
  final List<BreedInfoModel> filteredBreeds;
  final List<String> comparisonSelectedBreedIds;
  final List<KnowledgeArticleModel> articles;
  final String searchQuery;
  final String? selectedSpeciesFilter;
  final bool isLoading;
  final String? errorMessage;

  const KnowledgeState({
    this.breeds = const [],
    this.filteredBreeds = const [],
    this.comparisonSelectedBreedIds = const ['kangayam', 'gir'],
    this.articles = const [],
    this.searchQuery = '',
    this.selectedSpeciesFilter,
    this.isLoading = false,
    this.errorMessage,
  });

  KnowledgeState copyWith({
    List<BreedInfoModel>? breeds,
    List<BreedInfoModel>? filteredBreeds,
    List<String>? comparisonSelectedBreedIds,
    List<KnowledgeArticleModel>? articles,
    String? searchQuery,
    String? selectedSpeciesFilter,
    bool clearSpeciesFilter = false,
    bool? isLoading,
    String? errorMessage,
  }) {
    return KnowledgeState(
      breeds: breeds ?? this.breeds,
      filteredBreeds: filteredBreeds ?? this.filteredBreeds,
      comparisonSelectedBreedIds: comparisonSelectedBreedIds ?? this.comparisonSelectedBreedIds,
      articles: articles ?? this.articles,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedSpeciesFilter: clearSpeciesFilter ? null : (selectedSpeciesFilter ?? this.selectedSpeciesFilter),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        breeds,
        filteredBreeds,
        comparisonSelectedBreedIds,
        articles,
        searchQuery,
        selectedSpeciesFilter,
        isLoading,
        errorMessage,
      ];
}

final knowledgeControllerProvider = StateNotifierProvider<KnowledgeController, KnowledgeState>((ref) {
  final repo = ref.watch(knowledgeRepositoryProvider);
  return KnowledgeController(repo);
});

class KnowledgeController extends StateNotifier<KnowledgeState> {
  final KnowledgeRepository _repository;

  KnowledgeController(this._repository) : super(const KnowledgeState()) {
    loadKnowledgeData();
  }

  Future<void> loadKnowledgeData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final breeds = await _repository.getAllBreeds();
      final articles = await _repository.getArticles();

      state = state.copyWith(
        isLoading: false,
        breeds: breeds,
        articles: articles,
      );
      _applyFilters();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Failed to load knowledge hub.');
    }
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  void filterSpecies(String? species) {
    if (species == null) {
      state = state.copyWith(clearSpeciesFilter: true);
    } else {
      state = state.copyWith(selectedSpeciesFilter: species);
    }
    _applyFilters();
  }

  void toggleComparisonBreed(String breedId) {
    final current = List<String>.from(state.comparisonSelectedBreedIds);
    if (current.contains(breedId)) {
      if (current.length > 1) current.remove(breedId);
    } else {
      if (current.length < 3) current.add(breedId);
    }
    state = state.copyWith(comparisonSelectedBreedIds: current);
  }

  void _applyFilters() {
    List<BreedInfoModel> list = List.from(state.breeds);

    if (state.searchQuery.trim().isNotEmpty) {
      final q = state.searchQuery.trim().toLowerCase();
      list = list.where((b) {
        return b.name.toLowerCase().contains(q) ||
            b.origin.toLowerCase().contains(q) ||
            b.climateSuitability.toLowerCase().contains(q);
      }).toList();
    }

    if (state.selectedSpeciesFilter != null) {
      list = list.where((b) => b.species.contains(state.selectedSpeciesFilter!)).toList();
    }

    state = state.copyWith(filteredBreeds: list);
  }
}
