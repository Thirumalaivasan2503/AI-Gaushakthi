import 'package:equatable/equatable.dart';

/// Disease Database Entity
class DiseaseModel extends Equatable {
  final String id;
  final String name;
  final List<String> symptoms;
  final String causes;
  final String severity; // Low, Medium, High, Critical/Emergency
  final String treatment;
  final String medicine;
  final String recoveryPeriod;
  final String vaccinationInfo;
  final String isolationRecommendation;
  final bool isEmergency;
  final String governmentAdvisory;
  final bool isBookmarked;

  const DiseaseModel({
    required this.id,
    required this.name,
    required this.symptoms,
    required this.causes,
    required this.severity,
    required this.treatment,
    required this.medicine,
    required this.recoveryPeriod,
    required this.vaccinationInfo,
    required this.isolationRecommendation,
    this.isEmergency = false,
    required this.governmentAdvisory,
    this.isBookmarked = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'symptoms': symptoms,
        'causes': causes,
        'severity': severity,
        'treatment': treatment,
        'medicine': medicine,
        'recovery_period': recoveryPeriod,
        'vaccination_info': vaccinationInfo,
        'isolation_recommendation': isolationRecommendation,
        'is_emergency': isEmergency,
        'government_advisory': governmentAdvisory,
        'is_bookmarked': isBookmarked,
      };

  factory DiseaseModel.fromJson(Map<String, dynamic> json) => DiseaseModel(
        id: json['id'] ?? '',
        name: json['name'] ?? 'Foot & Mouth Disease',
        symptoms: List<String>.from(json['symptoms'] ?? []),
        causes: json['causes'] ?? 'Picornavirus Infection',
        severity: json['severity'] ?? 'High',
        treatment: json['treatment'] ?? 'Antiseptic foot bath & antibiotics',
        medicine: json['medicine'] ?? 'Oxytetracycline & Potassium Permanganate',
        recoveryPeriod: json['recovery_period'] ?? '14-21 Days',
        vaccinationInfo: json['vaccination_info'] ?? 'FMD Quadrivalent Vaccine bi-annually',
        isolationRecommendation: json['isolation_recommendation'] ?? 'Isolate animal in dry shaded shed away from herd for 21 days',
        isEmergency: json['is_emergency'] ?? false,
        governmentAdvisory: json['government_advisory'] ?? 'Mandatory ring vaccination drive active across district',
        isBookmarked: json['is_bookmarked'] ?? false,
      );

  DiseaseModel copyWith({bool? isBookmarked}) {
    return DiseaseModel(
      id: id,
      name: name,
      symptoms: symptoms,
      causes: causes,
      severity: severity,
      treatment: treatment,
      medicine: medicine,
      recoveryPeriod: recoveryPeriod,
      vaccinationInfo: vaccinationInfo,
      isolationRecommendation: isolationRecommendation,
      isEmergency: isEmergency,
      governmentAdvisory: governmentAdvisory,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        symptoms,
        causes,
        severity,
        treatment,
        medicine,
        recoveryPeriod,
        vaccinationInfo,
        isolationRecommendation,
        isEmergency,
        governmentAdvisory,
        isBookmarked,
      ];
}
