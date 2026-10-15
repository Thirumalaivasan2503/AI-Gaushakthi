import 'package:flutter_test/flutter_test.dart';
import 'package:indigenous_livestock_app/features/veterinary/domain/models/consultation_model.dart';
import 'package:indigenous_livestock_app/features/veterinary/domain/models/disease_model.dart';
import 'package:indigenous_livestock_app/features/veterinary/domain/models/vet_report_review_model.dart';
import 'package:indigenous_livestock_app/features/knowledge/domain/models/breed_info_model.dart';

void main() {
  group('Module 2 Domain Models Unit Tests', () {
    test('ConsultationModel serialization & status', () {
      const consult = ConsultationModel(
        id: 'c1',
        farmerName: 'Ramesh',
        farmerMobile: '+919876543210',
        animalTag: 'KANG-01',
        breed: 'Kangayam',
        type: ConsultationType.video,
        appointmentSlot: 'Today 4PM',
      );

      final json = consult.toJson();
      expect(json['type'], equals('video'));
      expect(ConsultationModel.fromJson(json).farmerName, equals('Ramesh'));
    });

    test('DiseaseModel serialization & emergency flag', () {
      const disease = DiseaseModel(
        id: 'd1',
        name: 'Foot and Mouth Disease',
        symptoms: ['Fever', 'Blisters'],
        causes: 'Aphthovirus',
        severity: 'Emergency',
        treatment: 'Foot wash',
        medicine: 'KMnO4',
        recoveryPeriod: '14 Days',
        vaccinationInfo: 'FMD Bi-annually',
        isolationRecommendation: '21 days isolation',
        isEmergency: true,
        governmentAdvisory: 'Mandatory Ring Vaccination',
      );

      final json = disease.toJson();
      expect(json['is_emergency'], isTrue);
      expect(DiseaseModel.fromJson(json).name, equals('Foot and Mouth Disease'));
    });

    test('BreedInfoModel serialization & attributes', () {
      const breed = BreedInfoModel(
        id: 'kangayam',
        name: 'Kangayam Cattle',
        species: 'Cattle',
        origin: 'Kongu Nadu',
        nativeRegion: 'Coimbatore',
        history: 'Draught breed',
        climateSuitability: 'Extreme Heat',
        milkProductionLiters: '600-800 L',
        diseaseResistanceScore: 98.5,
        bodyWeightKg: '450-550 kg',
        lifespanYears: '18-22 Yrs',
        feedRequirement: 'Low',
        maintenanceCost: 'Low',
        breedingCharacteristics: 'High fertility',
        economicValue: 'Fuel savings',
        advantages: ['Heat Tolerance'],
        disadvantages: ['Moderate milk'],
        interestingFacts: ['Jallikattu'],
        governmentRecognition: 'NBAGR Registered',
        conservationStatus: 'Protected',
        suitableStates: ['TN'],
        recommendedTempRange: '20-48 C',
        rainfallRangeMm: '400-900',
        waterRequirement: 'Low',
      );

      final json = breed.toJson();
      expect(json['disease_resistance_score'], equals(98.5));
      expect(BreedInfoModel.fromJson(json).name, equals('Kangayam Cattle'));
    });
  });
}
