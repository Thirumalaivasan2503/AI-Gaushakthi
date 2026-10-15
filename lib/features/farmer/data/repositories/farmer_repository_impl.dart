import '../../../../core/services/api_service.dart';
import '../../../../core/services/sqlite_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/models/farmer_profile_model.dart';
import '../../domain/models/livestock_model.dart';
import '../../domain/models/medical_vaccination_model.dart';
import '../../domain/models/feed_environmental_model.dart';
import '../../domain/models/document_upload_model.dart';
import '../../domain/repositories/farmer_repository.dart';

class FarmerRepositoryImpl implements FarmerRepository {
  final ApiService apiService;
  final SQLiteService sqliteService;
  final StorageService storageService;

  FarmerProfileModel? _cachedProfile;
  final List<LivestockModel> _livestockList = [];
  final List<MedicalRecordModel> _medicalRecords = [];
  final List<VaccinationRecordModel> _vaccinationRecords = [];
  FeedEnvironmentalModel? _cachedFeedEnv;
  final List<DocumentUploadModel> _documents = [];

  FarmerRepositoryImpl({
    required this.apiService,
    required this.sqliteService,
    required this.storageService,
  }) {
    _initializeSeedData();
  }

  void _initializeSeedData() {
    _cachedProfile = const FarmerProfileModel(
      id: 'frm_1001',
      userId: 'usr_1001',
      fullName: 'Ramesh Kumar',
      mobile: '+91 98765 43210',
      email: 'ramesh@pasumitra.org',
      state: 'Tamil Nadu',
      district: 'Coimbatore',
      taluk: 'Pollachi',
      village: 'Kottur',
      farmName: 'Sri Amman Indigenous Breed Farm',
      farmSizeAcres: 5.5,
      farmingExperienceYears: 14,
      farmingType: 'Rural Mixed Dairy & Draft',
      primaryLivestockType: 'Kangayam Cattle & Tellicherry Goats',
      monthlyFarmingBudget: 30000.0,
      feedBudget: 18000.0,
      medicalBudget: 6000.0,
    );

    _livestockList.addAll([
      const LivestockModel(
        id: 'anim_1',
        animalId: 'KANG-01',
        name: 'Valli',
        breed: 'Kangayam Cattle',
        species: LivestockSpecies.cattle,
        gender: 'Female',
        dob: '2021-04-12',
        ageYears: 3.2,
        weightKg: 420.0,
        heightCm: 138.0,
        color: 'Greyish White',
        earTagNumber: 'TAG-TN-9801',
        purchaseDate: '2021-08-10',
        purchaseCost: 55000.0,
        healthStatus: LivestockHealthStatus.healthy,
      ),
      const LivestockModel(
        id: 'anim_2',
        animalId: 'SAHI-02',
        name: 'Ganga',
        breed: 'Sahiwal Cow',
        species: LivestockSpecies.cattle,
        gender: 'Female',
        dob: '2020-01-20',
        ageYears: 4.5,
        weightKg: 460.0,
        heightCm: 142.0,
        color: 'Reddish Brown',
        earTagNumber: 'TAG-TN-9802',
        purchaseDate: '2020-05-15',
        purchaseCost: 68000.0,
        healthStatus: LivestockHealthStatus.lactating,
      ),
      const LivestockModel(
        id: 'anim_3',
        animalId: 'BARG-03',
        name: 'Bhairav',
        breed: 'Bargur Cattle',
        species: LivestockSpecies.cattle,
        gender: 'Male',
        dob: '2022-09-05',
        ageYears: 1.8,
        weightKg: 310.0,
        heightCm: 125.0,
        color: 'Brown with White Patches',
        earTagNumber: 'TAG-TN-9803',
        purchaseDate: '2022-11-01',
        purchaseCost: 40000.0,
        healthStatus: LivestockHealthStatus.underTreatment,
      ),
      const LivestockModel(
        id: 'anim_4',
        animalId: 'TELL-04',
        name: 'Malu',
        breed: 'Tellicherry Goat',
        species: LivestockSpecies.goat,
        gender: 'Female',
        dob: '2023-02-14',
        ageYears: 1.4,
        weightKg: 38.0,
        heightCm: 72.0,
        color: 'White & Black Spot',
        earTagNumber: 'TAG-TN-9804',
        purchaseDate: '2023-04-10',
        purchaseCost: 12000.0,
        healthStatus: LivestockHealthStatus.pregnant,
      ),
    ]);

    _medicalRecords.addAll([
      const MedicalRecordModel(
        id: 'med_101',
        livestockId: 'anim_3',
        diseaseName: 'Mild Bovine Ephemeral Fever',
        diagnosisDate: '2024-07-20',
        pastTreatments: 'Anti-inflammatory Injection & Oral Electrol',
        hospitalVisitLocation: 'Pollachi District Vet Hospital',
        veterinaryDoctorName: 'Dr. Ananya Sharma (Vet Expert)',
        medicinesPrescribed: 'Meloxicam & B-Complex Syrup',
        recoveryStatus: 'Under Medication',
        medicalNotes: 'Fever subsided, eating green fodder normally.',
      ),
    ]);

    _vaccinationRecords.addAll([
      const VaccinationRecordModel(
        id: 'vac_201',
        livestockId: 'anim_1',
        vaccineName: 'FMD Quadrivalent Vaccine',
        vaccinationDate: '2024-01-15',
        nextDueDate: '2024-08-15',
        vaccinatedBy: 'Dr. Ananya Sharma',
        isCompleted: true,
      ),
      const VaccinationRecordModel(
        id: 'vac_202',
        livestockId: 'anim_2',
        vaccineName: 'Haemorrhagic Septicaemia (HS)',
        vaccinationDate: '2024-02-10',
        nextDueDate: '2024-08-20',
        vaccinatedBy: 'Livestock Inspector Periasamy',
        isCompleted: true,
      ),
      const VaccinationRecordModel(
        id: 'vac_203',
        livestockId: 'anim_4',
        vaccineName: 'PPR Goat Plague Vaccine',
        vaccinationDate: '2024-03-01',
        nextDueDate: '2024-09-01',
        vaccinatedBy: 'Dr. Ananya Sharma',
        isCompleted: true,
      ),
    ]);

    _cachedFeedEnv = const FeedEnvironmentalModel(
      id: 'feed_301',
      farmerId: 'frm_1001',
    );

    _documents.addAll([
      const DocumentUploadModel(
        id: 'doc_401',
        title: 'FMD Vaccination Certificate 2024',
        category: DocumentCategory.vaccinationCertificate,
        filePath: 'certificates/fmd_cert_valli.pdf',
        fileName: 'fmd_cert_valli.pdf',
        fileSizeBytes: 850000.0,
        format: DocumentFormat.pdf,
        status: UploadStatus.completed,
        uploadTimestamp: '2024-01-15 11:30 AM',
      ),
      const DocumentUploadModel(
        id: 'doc_402',
        title: 'Bargur Cattle Purchase Invoice',
        category: DocumentCategory.invoiceReceipt,
        filePath: 'invoices/bargur_invoice.jpg',
        fileName: 'bargur_invoice.jpg',
        fileSizeBytes: 1450000.0,
        format: DocumentFormat.jpeg,
        status: UploadStatus.completed,
        uploadTimestamp: '2022-11-01 04:15 PM',
      ),
    ]);
  }

  @override
  Future<FarmerProfileModel> getFarmerProfile() async {
    return _cachedProfile!;
  }

  @override
  Future<void> updateFarmerProfile(FarmerProfileModel profile) async {
    _cachedProfile = profile;
    await sqliteService.cacheUserProfile(profile.toJson());
  }

  @override
  Future<List<LivestockModel>> getLivestockList() async {
    return List.unmodifiable(_livestockList);
  }

  @override
  Future<LivestockModel?> getLivestockById(String id) async {
    try {
      return _livestockList.firstWhere((a) => a.id == id || a.animalId == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addLivestock(LivestockModel animal) async {
    _livestockList.insert(0, animal);
    await sqliteService.addPendingSync('ADD_LIVESTOCK', animal.toJson());
  }

  @override
  Future<void> updateLivestock(LivestockModel animal) async {
    final index = _livestockList.indexWhere((a) => a.id == animal.id);
    if (index != -1) {
      _livestockList[index] = animal;
      await sqliteService.addPendingSync('UPDATE_LIVESTOCK', animal.toJson());
    }
  }

  @override
  Future<void> deleteLivestock(String id) async {
    _livestockList.removeWhere((a) => a.id == id);
    await sqliteService.addPendingSync('DELETE_LIVESTOCK', {'id': id});
  }

  @override
  Future<List<MedicalRecordModel>> getMedicalRecords(String livestockId) async {
    if (livestockId.isEmpty) return List.unmodifiable(_medicalRecords);
    return _medicalRecords.where((m) => m.livestockId == livestockId).toList();
  }

  @override
  Future<List<VaccinationRecordModel>> getVaccinationRecords(String livestockId) async {
    if (livestockId.isEmpty) return List.unmodifiable(_vaccinationRecords);
    return _vaccinationRecords.where((v) => v.livestockId == livestockId).toList();
  }

  @override
  Future<void> addMedicalRecord(MedicalRecordModel record) async {
    _medicalRecords.insert(0, record);
    await sqliteService.addPendingSync('ADD_MEDICAL_RECORD', record.toJson());
  }

  @override
  Future<void> addVaccinationRecord(VaccinationRecordModel record) async {
    _vaccinationRecords.insert(0, record);
    await sqliteService.addPendingSync('ADD_VACCINATION_RECORD', record.toJson());
  }

  @override
  Future<FeedEnvironmentalModel> getFeedEnvironmentalData() async {
    return _cachedFeedEnv!;
  }

  @override
  Future<void> saveFeedEnvironmentalData(FeedEnvironmentalModel data) async {
    _cachedFeedEnv = data;
    await sqliteService.addPendingSync('SAVE_FEED_ENV', data.toJson());
  }

  @override
  Future<List<DocumentUploadModel>> getUploadedDocuments() async {
    return List.unmodifiable(_documents);
  }

  @override
  Future<DocumentUploadModel> uploadDocument({
    required String title,
    required DocumentCategory category,
    required String filePath,
    required DocumentFormat format,
  }) async {
    final doc = DocumentUploadModel(
      id: 'doc_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      category: category,
      filePath: filePath,
      fileName: filePath.split('/').last,
      fileSizeBytes: 1250000.0,
      format: format,
      status: UploadStatus.completed,
      uploadTimestamp: DateTime.now().toString(),
    );
    _documents.insert(0, doc);
    await sqliteService.addPendingSync('UPLOAD_DOC', doc.toJson());
    return doc;
  }
}
