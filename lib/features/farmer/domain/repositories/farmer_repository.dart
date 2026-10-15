import '../models/farmer_profile_model.dart';
import '../models/livestock_model.dart';
import '../models/medical_vaccination_model.dart';
import '../models/feed_environmental_model.dart';
import '../models/document_upload_model.dart';

abstract class FarmerRepository {
  // Profile Operations
  Future<FarmerProfileModel> getFarmerProfile();
  Future<void> updateFarmerProfile(FarmerProfileModel profile);

  // Livestock Operations
  Future<List<LivestockModel>> getLivestockList();
  Future<LivestockModel?> getLivestockById(String id);
  Future<void> addLivestock(LivestockModel animal);
  Future<void> updateLivestock(LivestockModel animal);
  Future<void> deleteLivestock(String id);

  // Medical & Vaccination Operations
  Future<List<MedicalRecordModel>> getMedicalRecords(String livestockId);
  Future<List<VaccinationRecordModel>> getVaccinationRecords(String livestockId);
  Future<void> addMedicalRecord(MedicalRecordModel record);
  Future<void> addVaccinationRecord(VaccinationRecordModel record);

  // Feed & Environmental Operations
  Future<FeedEnvironmentalModel> getFeedEnvironmentalData();
  Future<void> saveFeedEnvironmentalData(FeedEnvironmentalModel data);

  // Document Upload Operations
  Future<List<DocumentUploadModel>> getUploadedDocuments();
  Future<DocumentUploadModel> uploadDocument({
    required String title,
    required DocumentCategory category,
    required String filePath,
    required DocumentFormat format,
  });
}
