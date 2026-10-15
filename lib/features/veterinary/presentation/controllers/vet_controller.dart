import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/api_service.dart';
import '../../data/repositories/vet_repository_impl.dart';
import '../../domain/models/consultation_model.dart';
import '../../domain/models/disease_model.dart';
import '../../domain/models/vet_report_review_model.dart';
import '../../domain/repositories/vet_repository.dart';

final vetRepositoryProvider = Provider<VetRepository>((ref) {
  return VetRepositoryImpl(apiService: ref.watch(apiServiceProvider));
});

class VetState extends Equatable {
  final List<ConsultationModel> consultations;
  final List<VetReportReviewModel> pendingReports;
  final List<DiseaseModel> diseases;
  final List<DiseaseModel> filteredDiseases;
  final String diseaseSearchQuery;
  final String? selectedSeverityFilter;
  final bool isLoading;
  final String? errorMessage;

  const VetState({
    this.consultations = const [],
    this.pendingReports = const [],
    this.diseases = const [],
    this.filteredDiseases = const [],
    this.diseaseSearchQuery = '',
    this.selectedSeverityFilter,
    this.isLoading = false,
    this.errorMessage,
  });

  VetState copyWith({
    List<ConsultationModel>? consultations,
    List<VetReportReviewModel>? pendingReports,
    List<DiseaseModel>? diseases,
    List<DiseaseModel>? filteredDiseases,
    String? diseaseSearchQuery,
    String? selectedSeverityFilter,
    bool clearSeverityFilter = false,
    bool? isLoading,
    String? errorMessage,
  }) {
    return VetState(
      consultations: consultations ?? this.consultations,
      pendingReports: pendingReports ?? this.pendingReports,
      diseases: diseases ?? this.diseases,
      filteredDiseases: filteredDiseases ?? this.filteredDiseases,
      diseaseSearchQuery: diseaseSearchQuery ?? this.diseaseSearchQuery,
      selectedSeverityFilter: clearSeverityFilter ? null : (selectedSeverityFilter ?? this.selectedSeverityFilter),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        consultations,
        pendingReports,
        diseases,
        filteredDiseases,
        diseaseSearchQuery,
        selectedSeverityFilter,
        isLoading,
        errorMessage,
      ];
}

final vetControllerProvider = StateNotifierProvider<VetController, VetState>((ref) {
  final repo = ref.watch(vetRepositoryProvider);
  return VetController(repo);
});

class VetController extends StateNotifier<VetState> {
  final VetRepository _repository;

  VetController(this._repository) : super(const VetState()) {
    loadVetData();
  }

  Future<void> loadVetData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final consults = await _repository.getConsultations();
      final reports = await _repository.getPendingReports();
      final diseases = await _repository.getDiseases();

      state = state.copyWith(
        isLoading: false,
        consultations: consults,
        pendingReports: reports,
        diseases: diseases,
      );
      _applyDiseaseFilters();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Failed to load veterinary data.');
    }
  }

  void searchDiseases(String query) {
    state = state.copyWith(diseaseSearchQuery: query);
    _applyDiseaseFilters();
  }

  void filterDiseaseSeverity(String? severity) {
    if (severity == null) {
      state = state.copyWith(clearSeverityFilter: true);
    } else {
      state = state.copyWith(selectedSeverityFilter: severity);
    }
    _applyDiseaseFilters();
  }

  void _applyDiseaseFilters() {
    List<DiseaseModel> list = List.from(state.diseases);

    if (state.diseaseSearchQuery.trim().isNotEmpty) {
      final q = state.diseaseSearchQuery.trim().toLowerCase();
      list = list.where((d) {
        return d.name.toLowerCase().contains(q) ||
            d.causes.toLowerCase().contains(q) ||
            d.symptoms.any((s) => s.toLowerCase().contains(q));
      }).toList();
    }

    if (state.selectedSeverityFilter != null) {
      list = list.where((d) => d.severity.contains(state.selectedSeverityFilter!)).toList();
    }

    state = state.copyWith(filteredDiseases: list);
  }

  Future<void> reviewReport(String reportId, VetReportReviewModel updated) async {
    state = state.copyWith(isLoading: true);
    await _repository.reviewReport(reportId, updated);
    await loadVetData();
  }

  Future<void> toggleBookmarkDisease(String diseaseId) async {
    await _repository.toggleBookmarkDisease(diseaseId);
    await loadVetData();
  }
}
