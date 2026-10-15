import 'package:flutter_test/flutter_test.dart';
import 'package:indigenous_livestock_app/features/farmer/domain/models/farmer_profile_model.dart';
import 'package:indigenous_livestock_app/features/farmer/domain/models/livestock_model.dart';
import 'package:indigenous_livestock_app/features/farmer/domain/models/medical_vaccination_model.dart';
import 'package:indigenous_livestock_app/features/farmer/domain/models/feed_environmental_model.dart';
import 'package:indigenous_livestock_app/features/farmer/domain/models/document_upload_model.dart';
import 'package:indigenous_livestock_app/features/farmer/domain/repositories/farmer_repository.dart';
import 'package:indigenous_livestock_app/features/farmer/presentation/controllers/farmer_controller.dart';

class MockFarmerRepository implements FarmerRepository {
  final List<LivestockModel> mockAnimals = [
    const LivestockModel(
      id: 'a1',
      animalId: 'KANG-01',
      name: 'Valli',
      breed: 'Kangayam Cattle',
      species: LivestockSpecies.cattle,
      gender: 'Female',
      dob: '2021-04-12',
      ageYears: 3.2,
      weightKg: 420.0,
      heightCm: 138.0,
      color: 'Grey',
      earTagNumber: 'TAG-101',
      purchaseDate: '2021-08-10',
      purchaseCost: 55000.0,
      healthStatus: LivestockHealthStatus.healthy,
    ),
    const LivestockModel(
      id: 'a2',
      animalId: 'SAHI-02',
      name: 'Ganga',
      breed: 'Sahiwal Cow',
      species: LivestockSpecies.cattle,
      gender: 'Female',
      dob: '2020-01-20',
      ageYears: 4.5,
      weightKg: 460.0,
      heightCm: 142.0,
      color: 'Brown',
      earTagNumber: 'TAG-102',
      purchaseDate: '2020-05-15',
      purchaseCost: 68000.0,
      healthStatus: LivestockHealthStatus.lactating,
    ),
  ];

  @override
  Future<FarmerProfileModel> getFarmerProfile() async => const FarmerProfileModel(
        id: 'f1',
        userId: 'u1',
        fullName: 'Test Farmer',
        mobile: '+919876543210',
        email: 'test@pasumitra.org',
        state: 'TN',
        district: 'Coimbatore',
        village: 'Kottur',
        farmName: 'Test Farm',
      );

  @override
  Future<void> updateFarmerProfile(FarmerProfileModel profile) async {}

  @override
  Future<List<LivestockModel>> getLivestockList() async => mockAnimals;

  @override
  Future<LivestockModel?> getLivestockById(String id) async => mockAnimals.first;

  @override
  Future<void> addLivestock(LivestockModel animal) async => mockAnimals.add(animal);

  @override
  Future<void> updateLivestock(LivestockModel animal) async {}

  @override
  Future<void> deleteLivestock(String id) async => mockAnimals.removeWhere((a) => a.id == id);

  @override
  Future<List<MedicalRecordModel>> getMedicalRecords(String livestockId) async => [];

  @override
  Future<List<VaccinationRecordModel>> getVaccinationRecords(String livestockId) async => [];

  @override
  Future<void> addMedicalRecord(MedicalRecordModel record) async {}

  @override
  Future<void> addVaccinationRecord(VaccinationRecordModel record) async {}

  @override
  Future<FeedEnvironmentalModel> getFeedEnvironmentalData() async => const FeedEnvironmentalModel(id: 'fe1', farmerId: 'f1');

  @override
  Future<void> saveFeedEnvironmentalData(FeedEnvironmentalModel data) async {}

  @override
  Future<List<DocumentUploadModel>> getUploadedDocuments() async => [];

  @override
  Future<DocumentUploadModel> uploadDocument({
    required String title,
    required DocumentCategory category,
    required String filePath,
    required DocumentFormat format,
  }) async {
    return DocumentUploadModel(
      id: 'd1',
      title: title,
      category: category,
      filePath: filePath,
      fileName: 'doc.pdf',
      fileSizeBytes: 1000,
      format: format,
      uploadTimestamp: '2024-01-01',
    );
  }
}

void main() {
  group('FarmerController Riverpod State Tests', () {
    late MockFarmerRepository mockRepo;
    late FarmerController controller;

    setUp(() {
      mockRepo = MockFarmerRepository();
      controller = FarmerController(mockRepo);
    });

    test('loadAllFarmerData initializes livestock list', () async {
      await controller.loadAllFarmerData();
      expect(controller.debugState.livestockList.length, equals(2));
      expect(controller.debugState.filteredLivestockList.length, equals(2));
    });

    test('searchLivestock filters animals by name or breed', () async {
      await controller.loadAllFarmerData();

      controller.searchLivestock('Valli');
      expect(controller.debugState.filteredLivestockList.length, equals(1));
      expect(controller.debugState.filteredLivestockList.first.name, equals('Valli'));

      controller.searchLivestock('Sahiwal');
      expect(controller.debugState.filteredLivestockList.length, equals(1));
      expect(controller.debugState.filteredLivestockList.first.breed, equals('Sahiwal Cow'));

      controller.searchLivestock('');
      expect(controller.debugState.filteredLivestockList.length, equals(2));
    });

    test('filterByBreed filters animals by specific breed', () async {
      await controller.loadAllFarmerData();

      controller.filterByBreed('Kangayam Cattle');
      expect(controller.debugState.filteredLivestockList.length, equals(1));
      expect(controller.debugState.filteredLivestockList.first.breed, equals('Kangayam Cattle'));

      controller.filterByBreed(null);
      expect(controller.debugState.filteredLivestockList.length, equals(2));
    });

    test('filterByHealthStatus filters by health status', () async {
      await controller.loadAllFarmerData();

      controller.filterByHealthStatus(LivestockHealthStatus.lactating);
      expect(controller.debugState.filteredLivestockList.length, equals(1));
      expect(controller.debugState.filteredLivestockList.first.name, equals('Ganga'));

      controller.filterByHealthStatus(null);
      expect(controller.debugState.filteredLivestockList.length, equals(2));
    });
  });
}
