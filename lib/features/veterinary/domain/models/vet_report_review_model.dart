import 'package:equatable/equatable.dart';

enum ReviewStatus { pending, approved, rejected, infoRequested }

/// Veterinary Report Review Model
class VetReportReviewModel extends Equatable {
  final String id;
  final String farmerName;
  final String animalTag;
  final String breed;
  final String submittedDate;
  final String clinicalObservations;
  final List<String> imageUrls;
  final String pdfReportUrl;
  final ReviewStatus status;
  final String assignedSeverity; // Low, Medium, High, Emergency
  final String vetComments;
  final String recommendedTreatment;
  final String recommendedVaccines;

  const VetReportReviewModel({
    required this.id,
    required this.farmerName,
    required this.animalTag,
    required this.breed,
    required this.submittedDate,
    required this.clinicalObservations,
    this.imageUrls = const [],
    this.pdfReportUrl = '',
    this.status = ReviewStatus.pending,
    this.assignedSeverity = 'Medium',
    this.vetComments = '',
    this.recommendedTreatment = '',
    this.recommendedVaccines = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'farmer_name': farmerName,
        'animal_tag': animalTag,
        'breed': breed,
        'submitted_date': submittedDate,
        'clinical_observations': clinicalObservations,
        'image_urls': imageUrls,
        'pdf_report_url': pdfReportUrl,
        'status': status.name,
        'assigned_severity': assignedSeverity,
        'vet_comments': vetComments,
        'recommended_treatment': recommendedTreatment,
        'recommended_vaccines': recommendedVaccines,
      };

  factory VetReportReviewModel.fromJson(Map<String, dynamic> json) => VetReportReviewModel(
        id: json['id'] ?? '',
        farmerName: json['farmer_name'] ?? 'Ramesh Kumar',
        animalTag: json['animal_tag'] ?? 'KANG-01',
        breed: json['breed'] ?? 'Kangayam Cattle',
        submittedDate: json['submitted_date'] ?? 'Today 09:30 AM',
        clinicalObservations: json['clinical_observations'] ?? 'Loss of appetite, mild fever (103.5°F), reduced rumination.',
        imageUrls: List<String>.from(json['image_urls'] ?? []),
        pdfReportUrl: json['pdf_report_url'] ?? '',
        status: ReviewStatus.values.firstWhere((s) => s.name == json['status'], orElse: () => ReviewStatus.pending),
        assignedSeverity: json['assigned_severity'] ?? 'Medium',
        vetComments: json['vet_comments'] ?? '',
        recommendedTreatment: json['recommended_treatment'] ?? '',
        recommendedVaccines: json['recommended_vaccines'] ?? '',
      );

  VetReportReviewModel copyWith({
    ReviewStatus? status,
    String? assignedSeverity,
    String? vetComments,
    String? recommendedTreatment,
    String? recommendedVaccines,
  }) {
    return VetReportReviewModel(
      id: id,
      farmerName: farmerName,
      animalTag: animalTag,
      breed: breed,
      submittedDate: submittedDate,
      clinicalObservations: clinicalObservations,
      imageUrls: imageUrls,
      pdfReportUrl: pdfReportUrl,
      status: status ?? this.status,
      assignedSeverity: assignedSeverity ?? this.assignedSeverity,
      vetComments: vetComments ?? this.vetComments,
      recommendedTreatment: recommendedTreatment ?? this.recommendedTreatment,
      recommendedVaccines: recommendedVaccines ?? this.recommendedVaccines,
    );
  }

  @override
  List<Object?> get props => [
        id,
        farmerName,
        animalTag,
        breed,
        submittedDate,
        clinicalObservations,
        imageUrls,
        pdfReportUrl,
        status,
        assignedSeverity,
        vetComments,
        recommendedTreatment,
        recommendedVaccines,
      ];
}
