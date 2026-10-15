import 'package:flutter_test/flutter_test.dart';
import 'package:indigenous_livestock_app/features/farmer/domain/models/farmer_profile_model.dart';
import 'package:indigenous_livestock_app/features/farmer/domain/models/livestock_model.dart';
import 'package:indigenous_livestock_app/features/farmer/domain/models/medical_vaccination_model.dart';
import 'package:indigenous_livestock_app/features/farmer/domain/models/feed_environmental_model.dart';
import 'package:indigenous_livestock_app/features/farmer/domain/models/document_upload_model.dart';

void main() {
  group('Farmer Domain Models Unit Tests', () {
    test('FarmerProfileModel serialization & copyWith', () {
      const profile = FarmerProfileModel(
        id: 'frm_1',
        userId: 'usr_1',
        fullName: 'Ramesh Kumar',
        mobile: '+91 98765 43210',
        email: 'ramesh@pasumitra.org',
        state: 'Tamil Nadu',
        district: 'Coimbatore',
        village: 'Kottur',
        farmName: 'Amman Cattle Farm',
        productivityGoals: [ProductivityGoal.milkProduction, ProductivityGoal.diseaseResistant],
      );

      final json = profile.toJson();
      expect(json['full_name'], equals('Ramesh Kumar'));
      expect(json['district'], equals('Coimbatore'));

      final deserialized = FarmerProfileModel.fromJson(json);
      expect(deserialized.fullName, equals(profile.fullName));
      expect(deserialized.productivityGoals, contains(ProductivityGoal.milkProduction));

      final updated = profile.copyWith(farmName: 'Updated Amman Farm');
      expect(updated.farmName, equals('Updated Amman Farm'));
    });

    test('LivestockModel serialization & health statuses', () {
      const animal = LivestockModel(
        id: 'anim_101',
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
      );

      final json = animal.toJson();
      expect(json['animal_id'], equals('KANG-01'));
      expect(json['health_status'], equals('healthy'));

      final deserialized = LivestockModel.fromJson(json);
      expect(deserialized.name, equals('Valli'));
      expect(deserialized.healthStatus, equals(LivestockHealthStatus.healthy));
    });

    test('MedicalRecordModel & VaccinationRecordModel', () {
      const medical = MedicalRecordModel(
        id: 'med_1',
        livestockId: 'anim_101',
        diseaseName: 'Foot & Mouth Check',
        diagnosisDate: '2024-01-10',
        veterinaryDoctorName: 'Dr. Ananya Sharma',
        medicinesPrescribed: 'B-Complex Injection',
      );

      final medJson = medical.toJson();
      expect(medJson['disease_name'], equals('Foot & Mouth Check'));
      expect(MedicalRecordModel.fromJson(medJson).veterinaryDoctorName, equals('Dr. Ananya Sharma'));

      const vaccine = VaccinationRecordModel(
        id: 'vac_1',
        livestockId: 'anim_101',
        vaccineName: 'FMD Quadrivalent',
        vaccinationDate: '2024-01-15',
        nextDueDate: '2024-07-15',
        vaccinatedBy: 'Dr. Ananya Sharma',
      );

      final vacJson = vaccine.toJson();
      expect(vacJson['vaccine_name'], equals('FMD Quadrivalent'));
      expect(VaccinationRecordModel.fromJson(vacJson).nextDueDate, equals('2024-07-15'));
    });

    test('FeedEnvironmentalModel & DocumentUploadModel', () {
      const feedEnv = FeedEnvironmentalModel(
        id: 'fe_1',
        farmerId: 'frm_1',
        feedType: 'Napier Grass',
        climateZone: 'Semi-Arid Tropical',
      );

      expect(feedEnv.toJson()['climate_zone'], equals('Semi-Arid Tropical'));

      const doc = DocumentUploadModel(
        id: 'doc_1',
        title: 'Vaccine Cert',
        category: DocumentCategory.vaccinationCertificate,
        filePath: 'cert.pdf',
        fileName: 'cert.pdf',
        fileSizeBytes: 1024.0,
        format: DocumentFormat.pdf,
        uploadTimestamp: '2024-01-15',
      );

      expect(doc.toJson()['format'], equals('pdf'));
    });
  });
}
