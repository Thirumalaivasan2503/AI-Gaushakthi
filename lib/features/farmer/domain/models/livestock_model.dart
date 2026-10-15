import 'package:equatable/equatable.dart';

enum LivestockHealthStatus {
  healthy('Healthy', 'Normal physiological parameters'),
  underTreatment('Under Treatment', 'Receiving veterinary care/medication'),
  pregnant('Pregnant', 'Gestation period in progress'),
  lactating('Lactating', 'Active milk production phase'),
  sold('Sold', 'Transferred ownership');

  final String label;
  final String description;
  const LivestockHealthStatus(this.label, this.description);
}

enum LivestockSpecies {
  cattle('Cattle (Cow/Bull)'),
  goat('Goat (Capra hircus)'),
  sheep('Sheep (Ovis aries)'),
  buffalo('Buffalo (Bubalus bubalis)');

  final String displayName;
  const LivestockSpecies(this.displayName);
}

/// Primary Animal Entity Model
class LivestockModel extends Equatable {
  final String id;
  final String animalId; // Farmer custom or ear tag ID
  final String name;
  final String breed; // Kangayam, Sahiwal, Gir, Tellicherry, Bargur, etc.
  final LivestockSpecies species;
  final String gender;
  final String dob;
  final double ageYears;
  final double weightKg;
  final double heightCm;
  final String color;
  final String earTagNumber;
  final String identificationPhoto;
  final String purchaseDate;
  final double purchaseCost;
  final LivestockHealthStatus healthStatus;

  const LivestockModel({
    required this.id,
    required this.animalId,
    required this.name,
    required this.breed,
    required this.species,
    required this.gender,
    required this.dob,
    required this.ageYears,
    required this.weightKg,
    required this.heightCm,
    required this.color,
    required this.earTagNumber,
    this.identificationPhoto = '',
    required this.purchaseDate,
    required this.purchaseCost,
    this.healthStatus = LivestockHealthStatus.healthy,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'animal_id': animalId,
        'name': name,
        'breed': breed,
        'species': species.name,
        'gender': gender,
        'dob': dob,
        'age_years': ageYears,
        'weight_kg': weightKg,
        'height_cm': heightCm,
        'color': color,
        'ear_tag_number': earTagNumber,
        'identification_photo': identificationPhoto,
        'purchase_date': purchaseDate,
        'purchase_cost': purchaseCost,
        'health_status': healthStatus.name,
      };

  factory LivestockModel.fromJson(Map<String, dynamic> json) => LivestockModel(
        id: json['id'] ?? '',
        animalId: json['animal_id'] ?? '',
        name: json['name'] ?? '',
        breed: json['breed'] ?? 'Kangayam',
        species: LivestockSpecies.values.firstWhere(
          (s) => s.name == json['species'],
          orElse: () => LivestockSpecies.cattle,
        ),
        gender: json['gender'] ?? 'Female',
        dob: json['dob'] ?? '2022-03-10',
        ageYears: (json['age_years'] as num?)?.toDouble() ?? 2.5,
        weightKg: (json['weight_kg'] as num?)?.toDouble() ?? 380.0,
        heightCm: (json['height_cm'] as num?)?.toDouble() ?? 132.0,
        color: json['color'] ?? 'Greyish White',
        earTagNumber: json['ear_tag_number'] ?? 'TAG-TN-1001',
        identificationPhoto: json['identification_photo'] ?? '',
        purchaseDate: json['purchase_date'] ?? '2022-06-15',
        purchaseCost: (json['purchase_cost'] as num?)?.toDouble() ?? 45000.0,
        healthStatus: LivestockHealthStatus.values.firstWhere(
          (h) => h.name == json['health_status'],
          orElse: () => LivestockHealthStatus.healthy,
        ),
      );

  LivestockModel copyWith({
    String? id,
    String? animalId,
    String? name,
    String? breed,
    LivestockSpecies? species,
    String? gender,
    String? dob,
    double? ageYears,
    double? weightKg,
    double? heightCm,
    String? color,
    String? earTagNumber,
    String? identificationPhoto,
    String? purchaseDate,
    double? purchaseCost,
    LivestockHealthStatus? healthStatus,
  }) {
    return LivestockModel(
      id: id ?? this.id,
      animalId: animalId ?? this.animalId,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      species: species ?? this.species,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      ageYears: ageYears ?? this.ageYears,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      color: color ?? this.color,
      earTagNumber: earTagNumber ?? this.earTagNumber,
      identificationPhoto: identificationPhoto ?? this.identificationPhoto,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchaseCost: purchaseCost ?? this.purchaseCost,
      healthStatus: healthStatus ?? this.healthStatus,
    );
  }

  @override
  List<Object?> get props => [
        id,
        animalId,
        name,
        breed,
        species,
        gender,
        dob,
        ageYears,
        weightKg,
        heightCm,
        color,
        earTagNumber,
        identificationPhoto,
        purchaseDate,
        purchaseCost,
        healthStatus,
      ];
}
