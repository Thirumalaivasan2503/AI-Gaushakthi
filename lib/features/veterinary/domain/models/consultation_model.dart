import 'package:equatable/equatable.dart';

enum ConsultationType { video, audio, chat }
enum ConsultationStatus { scheduled, inProgress, completed, cancelled }

/// Consultation Appointment & Prescription Entity
class ConsultationModel extends Equatable {
  final String id;
  final String farmerName;
  final String farmerMobile;
  final String animalTag;
  final String breed;
  final ConsultationType type;
  final String appointmentSlot;
  final ConsultationStatus status;
  final String doctorNotes;
  final String prescriptionMedicines;
  final String assignedDiseaseSeverity; // Low, Medium, High, Emergency

  const ConsultationModel({
    required this.id,
    required this.farmerName,
    required this.farmerMobile,
    required this.animalTag,
    required this.breed,
    this.type = ConsultationType.video,
    required this.appointmentSlot,
    this.status = ConsultationStatus.scheduled,
    this.doctorNotes = '',
    this.prescriptionMedicines = '',
    this.assignedDiseaseSeverity = 'Low',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'farmer_name': farmerName,
        'farmer_mobile': farmerMobile,
        'animal_tag': animalTag,
        'breed': breed,
        'type': type.name,
        'appointment_slot': appointmentSlot,
        'status': status.name,
        'doctor_notes': doctorNotes,
        'prescription_medicines': prescriptionMedicines,
        'assigned_disease_severity': assignedDiseaseSeverity,
      };

  factory ConsultationModel.fromJson(Map<String, dynamic> json) => ConsultationModel(
        id: json['id'] ?? '',
        farmerName: json['farmer_name'] ?? 'Ramesh Kumar',
        farmerMobile: json['farmer_mobile'] ?? '+91 98765 43210',
        animalTag: json['animal_tag'] ?? 'KANG-01',
        breed: json['breed'] ?? 'Kangayam Cattle',
        type: ConsultationType.values.firstWhere((t) => t.name == json['type'], orElse: () => ConsultationType.video),
        appointmentSlot: json['appointment_slot'] ?? 'Today 04:00 PM',
        status: ConsultationStatus.values.firstWhere((s) => s.name == json['status'], orElse: () => ConsultationStatus.scheduled),
        doctorNotes: json['doctor_notes'] ?? '',
        prescriptionMedicines: json['prescription_medicines'] ?? '',
        assignedDiseaseSeverity: json['assigned_disease_severity'] ?? 'Low',
      );

  @override
  List<Object?> get props => [
        id,
        farmerName,
        farmerMobile,
        animalTag,
        breed,
        type,
        appointmentSlot,
        status,
        doctorNotes,
        prescriptionMedicines,
        assignedDiseaseSeverity,
      ];
}
