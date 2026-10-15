import 'package:equatable/equatable.dart';

/// Indigenous Breed Encyclopedia Model
class BreedInfoModel extends Equatable {
  final String id;
  final String name;
  final String species; // Cattle, Goat, Sheep, Buffalo
  final String imageAsset;
  final String origin;
  final String nativeRegion;
  final String history;
  final String climateSuitability;
  final String milkProductionLiters;
  final double diseaseResistanceScore; // Out of 100
  final String bodyWeightKg;
  final String lifespanYears;
  final String feedRequirement;
  final String maintenanceCost;
  final String breedingCharacteristics;
  final String economicValue;
  final List<String> advantages;
  final List<String> disadvantages;
  final List<String> interestingFacts;
  final String governmentRecognition;
  final String conservationStatus;
  final List<String> suitableStates;
  final String recommendedTempRange;
  final String rainfallRangeMm;
  final String waterRequirement;

  const BreedInfoModel({
    required this.id,
    required this.name,
    required this.species,
    this.imageAsset = '',
    required this.origin,
    required this.nativeRegion,
    required this.history,
    required this.climateSuitability,
    required this.milkProductionLiters,
    required this.diseaseResistanceScore,
    required this.bodyWeightKg,
    required this.lifespanYears,
    required this.feedRequirement,
    required this.maintenanceCost,
    required this.breedingCharacteristics,
    required this.economicValue,
    required this.advantages,
    required this.disadvantages,
    required this.interestingFacts,
    required this.governmentRecognition,
    required this.conservationStatus,
    required this.suitableStates,
    required this.recommendedTempRange,
    required this.rainfallRangeMm,
    required this.waterRequirement,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'species': species,
        'image_asset': imageAsset,
        'origin': origin,
        'native_region': nativeRegion,
        'history': history,
        'climate_suitability': climateSuitability,
        'milk_production_liters': milkProductionLiters,
        'disease_resistance_score': diseaseResistanceScore,
        'body_weight_kg': bodyWeightKg,
        'lifespan_years': lifespanYears,
        'feed_requirement': feedRequirement,
        'maintenance_cost': maintenanceCost,
        'breeding_characteristics': breedingCharacteristics,
        'economic_value': economicValue,
        'advantages': advantages,
        'disadvantages': disadvantages,
        'interesting_facts': interestingFacts,
        'government_recognition': governmentRecognition,
        'conservation_status': conservationStatus,
        'suitable_states': suitableStates,
        'recommended_temp_range': recommendedTempRange,
        'rainfall_range_mm': rainfallRangeMm,
        'water_requirement': waterRequirement,
      };

  factory BreedInfoModel.fromJson(Map<String, dynamic> json) => BreedInfoModel(
        id: json['id'] ?? '',
        name: json['name'] ?? 'Kangayam Cattle',
        species: json['species'] ?? 'Cattle',
        imageAsset: json['image_asset'] ?? '',
        origin: json['origin'] ?? 'Kongu Nadu, Tamil Nadu',
        nativeRegion: json['native_region'] ?? 'Coimbatore, Erode, Tiruppur, Karur',
        history: json['history'] ?? 'Bred for centuries by Palayakkarars for draft and drought endurance.',
        climateSuitability: json['climate_suitability'] ?? 'Semi-Arid & High Heat (up to 48°C)',
        milkProductionLiters: json['milk_production_liters'] ?? '600-800 L/lactation (A2 Protein)',
        diseaseResistanceScore: (json['disease_resistance_score'] as num?)?.toDouble() ?? 98.5,
        bodyWeightKg: json['body_weight_kg'] ?? '450-550 kg (Bull), 320-400 kg (Cow)',
        lifespanYears: json['lifespan_years'] ?? '18-22 Years',
        feedRequirement: json['feed_requirement'] ?? 'Low (Thrives on dry fodder & stover)',
        maintenanceCost: json['maintenance_cost'] ?? 'Low (₹120/day)',
        breedingCharacteristics: json['breeding_characteristics'] ?? 'High fertility rate & easy calving',
        economicValue: json['economic_value'] ?? 'Draft capability saves ₹35,000/yr in fuel',
        advantages: List<String>.from(json['advantages'] ?? []),
        disadvantages: List<String>.from(json['disadvantages'] ?? []),
        interestingFacts: List<String>.from(json['interesting_facts'] ?? []),
        governmentRecognition: json['government_recognition'] ?? 'NBAGR Registered',
        conservationStatus: json['conservation_status'] ?? 'Protected Native Breed',
        suitableStates: List<String>.from(json['suitable_states'] ?? ['Tamil Nadu', 'Karnataka', 'Andhra Pradesh']),
        recommendedTempRange: json['recommended_temp_range'] ?? '20°C - 48°C',
        rainfallRangeMm: json['rainfall_range_mm'] ?? '400 - 900 mm',
        waterRequirement: json['water_requirement'] ?? 'Low to Moderate',
      );

  @override
  List<Object?> get props => [
        id,
        name,
        species,
        imageAsset,
        origin,
        nativeRegion,
        history,
        climateSuitability,
        milkProductionLiters,
        diseaseResistanceScore,
        bodyWeightKg,
        lifespanYears,
        feedRequirement,
        maintenanceCost,
        breedingCharacteristics,
        economicValue,
        advantages,
        disadvantages,
        interestingFacts,
        governmentRecognition,
        conservationStatus,
        suitableStates,
        recommendedTempRange,
        rainfallRangeMm,
        waterRequirement,
      ];
}
