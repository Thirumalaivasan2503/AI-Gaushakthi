import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/sqlite_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../data/repositories/farmer_repository_impl.dart';
import '../../domain/models/document_upload_model.dart';
import '../../domain/models/farmer_profile_model.dart';
import '../../domain/models/feed_environmental_model.dart';
import '../../domain/models/livestock_model.dart';
import '../../domain/models/medical_vaccination_model.dart';
import '../../domain/repositories/farmer_repository.dart';

final farmerRepositoryProvider = Provider<FarmerRepository>((ref) {
  return FarmerRepositoryImpl(
    apiService: ref.watch(apiServiceProvider),
    sqliteService: ref.watch(sqliteServiceProvider),
    storageService: ref.watch(storageServiceProvider),
  );
});

class FarmerState extends Equatable {
  final FarmerProfileModel? profile;
  final List<LivestockModel> livestockList;
  final List<LivestockModel> filteredLivestockList;
  final String searchQuery;
  final String? selectedBreedFilter;
  final LivestockHealthStatus? selectedHealthFilter;
  final String sortBy; // 'recent', 'age', 'productivity'
  final List<MedicalRecordModel> medicalRecords;
  final List<VaccinationRecordModel> vaccinationRecords;
  final FeedEnvironmentalModel? feedEnv;
  final List<DocumentUploadModel> uploadedDocuments;
  final bool isLoading;
  final String? errorMessage;

  const FarmerState({
    this.profile,
    this.livestockList = const [],
    this.filteredLivestockList = const [],
    this.searchQuery = '',
    this.selectedBreedFilter,
    this.selectedHealthFilter,
    this.sortBy = 'recent',
    this.medicalRecords = const [],
    this.vaccinationRecords = const [],
    this.feedEnv,
    this.uploadedDocuments = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  FarmerState copyWith({
    FarmerProfileModel? profile,
    List<LivestockModel>? livestockList,
    List<LivestockModel>? filteredLivestockList,
    String? searchQuery,
    String? selectedBreedFilter,
    LivestockHealthStatus? selectedHealthFilter,
    bool clearBreedFilter = false,
    bool clearHealthFilter = false,
    String? sortBy,
    List<MedicalRecordModel>? medicalRecords,
    List<VaccinationRecordModel>? vaccinationRecords,
    FeedEnvironmentalModel? feedEnv,
    List<DocumentUploadModel>? uploadedDocuments,
    bool? isLoading,
    String? errorMessage,
  }) {
    return FarmerState(
      profile: profile ?? this.profile,
      livestockList: livestockList ?? this.livestockList,
      filteredLivestockList: filteredLivestockList ?? this.filteredLivestockList,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedBreedFilter: clearBreedFilter ? null : (selectedBreedFilter ?? this.selectedBreedFilter),
      selectedHealthFilter: clearHealthFilter ? null : (selectedHealthFilter ?? this.selectedHealthFilter),
      sortBy: sortBy ?? this.sortBy,
      medicalRecords: medicalRecords ?? this.medicalRecords,
      vaccinationRecords: vaccinationRecords ?? this.vaccinationRecords,
      feedEnv: feedEnv ?? this.feedEnv,
      uploadedDocuments: uploadedDocuments ?? this.uploadedDocuments,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  int get healthyCount => livestockList.where((a) => a.healthStatus == LivestockHealthStatus.healthy).length;
  int get vaccineDueCount => vaccinationRecords.where((v) => !v.isCompleted).length;

  @override
  List<Object?> get props => [
        profile,
        livestockList,
        filteredLivestockList,
        searchQuery,
        selectedBreedFilter,
        selectedHealthFilter,
        sortBy,
        medicalRecords,
        vaccinationRecords,
        feedEnv,
        uploadedDocuments,
        isLoading,
        errorMessage,
      ];
}

final farmerControllerProvider = StateNotifierProvider<FarmerController, FarmerState>((ref) {
  final repo = ref.watch(farmerRepositoryProvider);
  return FarmerController(repo);
});

class FarmerController extends StateNotifier<FarmerState> {
  final FarmerRepository _repository;

  FarmerController(this._repository) : super(const FarmerState()) {
    loadAllFarmerData();
  }

  Future<void> loadAllFarmerData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final profile = await _repository.getFarmerProfile();
      final livestock = await _repository.getLivestockList();
      final medicals = await _repository.getMedicalRecords('');
      final vaccinations = await _repository.getVaccinationRecords('');
      final feedEnv = await _repository.getFeedEnvironmentalData();
      final docs = await _repository.getUploadedDocuments();

      state = state.copyWith(
        isLoading: false,
        profile: profile,
        livestockList: livestock,
        medicalRecords: medicals,
        vaccinationRecords: vaccinations,
        feedEnv: feedEnv,
        uploadedDocuments: docs,
      );

      _applyFilters();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load farmer data.',
      );
    }
  }

  void searchLivestock(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  void filterByBreed(String? breed) {
    if (breed == null) {
      state = state.copyWith(clearBreedFilter: true);
    } else {
      state = state.copyWith(selectedBreedFilter: breed);
    }
    _applyFilters();
  }

  void filterByHealthStatus(LivestockHealthStatus? status) {
    if (status == null) {
      state = state.copyWith(clearHealthFilter: true);
    } else {
      state = state.copyWith(selectedHealthFilter: status);
    }
    _applyFilters();
  }

  void setSortBy(String sortOption) {
    state = state.copyWith(sortBy: sortOption);
    _applyFilters();
  }

  void _applyFilters() {
    List<LivestockModel> result = List.from(state.livestockList);

    // 1. Search Query
    if (state.searchQuery.trim().isNotEmpty) {
      final q = state.searchQuery.trim().toLowerCase();
      result = result.where((a) {
        return a.name.toLowerCase().contains(q) ||
            a.breed.toLowerCase().contains(q) ||
            a.animalId.toLowerCase().contains(q) ||
            a.earTagNumber.toLowerCase().contains(q);
      }).toList();
    }

    // 2. Breed Filter
    if (state.selectedBreedFilter != null && state.selectedBreedFilter!.isNotEmpty) {
      result = result.where((a) => a.breed == state.selectedBreedFilter).toList();
    }

    // 3. Health Filter
    if (state.selectedHealthFilter != null) {
      result = result.where((a) => a.healthStatus == state.selectedHealthFilter).toList();
    }

    // 4. Sort
    if (state.sortBy == 'age') {
      result.sort((a, b) => a.ageYears.compareTo(b.ageYears));
    } else if (state.sortBy == 'productivity') {
      result.sort((a, b) => b.weightKg.compareTo(a.weightKg));
    } else {
      // Recent
      result.sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));
    }

    state = state.copyWith(filteredLivestockList: result);
  }

  Future<void> addAnimal(LivestockModel animal) async {
    state = state.copyWith(isLoading: true);
    await _repository.addLivestock(animal);
    await loadAllFarmerData();
  }

  Future<void> updateAnimal(LivestockModel animal) async {
    state = state.copyWith(isLoading: true);
    await _repository.updateLivestock(animal);
    await loadAllFarmerData();
  }

  Future<void> deleteAnimal(String id) async {
    state = state.copyWith(isLoading: true);
    await _repository.deleteLivestock(id);
    await loadAllFarmerData();
  }

  Future<void> updateProfile(FarmerProfileModel profile) async {
    state = state.copyWith(isLoading: true);
    await _repository.updateFarmerProfile(profile);
    await loadAllFarmerData();
  }

  Future<void> addMedicalRecord(MedicalRecordModel record) async {
    state = state.copyWith(isLoading: true);
    await _repository.addMedicalRecord(record);
    await loadAllFarmerData();
  }

  Future<void> addVaccinationRecord(VaccinationRecordModel record) async {
    state = state.copyWith(isLoading: true);
    await _repository.addVaccinationRecord(record);
    await loadAllFarmerData();
  }

  Future<void> saveFeedEnvData(FeedEnvironmentalModel data) async {
    state = state.copyWith(isLoading: true);
    await _repository.saveFeedEnvironmentalData(data);
    await loadAllFarmerData();
  }

  Future<void> uploadDocument({
    required String title,
    required DocumentCategory category,
    required String filePath,
    required DocumentFormat format,
  }) async {
    state = state.copyWith(isLoading: true);
    await _repository.uploadDocument(
      title: title,
      category: category,
      filePath: filePath,
      format: format,
    );
    await loadAllFarmerData();
  }
}
