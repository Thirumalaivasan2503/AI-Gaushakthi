import 'package:equatable/equatable.dart';

/// Medical History Record
class MedicalRecordModel extends Equatable {
  final String id;
  final String livestockId;
  final String diseaseName;
  final String diagnosisDate;
  final String pastTreatments;
  final String hospitalVisitLocation;
  final String veterinaryDoctorName;
  final String medicinesPrescribed;
  final String recoveryStatus; // Fully Recovered, Under Medication, Critical, Stable
  final String medicalNotes;

  const MedicalRecordModel({
    required this.id,
    required this.livestockId,
    required this.diseaseName,
    required this.diagnosisDate,
    this.pastTreatments = '',
    this.hospitalVisitLocation = 'Pollachi Vet Hospital',
    required this.veterinaryDoctorName,
    required this.medicinesPrescribed,
    this.recoveryStatus = 'Fully Recovered',
    this.medicalNotes = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'livestock_id': livestockId,
        'disease_name': diseaseName,
        'diagnosis_date': diagnosisDate,
        'past_treatments': pastTreatments,
        'hospital_visit_location': hospitalVisitLocation,
        'veterinary_doctor_name': veterinaryDoctorName,
        'medicines_prescribed': medicinesPrescribed,
        'recovery_status': recoveryStatus,
        'medical_notes': medicalNotes,
      };

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) => MedicalRecordModel(
        id: json['id'] ?? '',
        livestockId: json['livestock_id'] ?? '',
        diseaseName: json['disease_name'] ?? 'Foot & Mouth Disease (FMD) Check',
        diagnosisDate: json['diagnosis_date'] ?? '2024-01-10',
        pastTreatments: json['past_treatments'] ?? 'Antiseptic Wash & Antibiotics',
        hospitalVisitLocation: json['hospital_visit_location'] ?? 'District Vet Clinic',
        veterinaryDoctorName: json['veterinary_doctor_name'] ?? 'Dr. Ananya Sharma',
        medicinesPrescribed: json['medicines_prescribed'] ?? 'Oxytet Spray & Multivitamin',
        recoveryStatus: json['recovery_status'] ?? 'Fully Recovered',
        medicalNotes: json['medical_notes'] ?? 'Animal recovered well with no drop in milk yield.',
      );

  @override
  List<Object?> get props => [
        id,
        livestockId,
        diseaseName,
        diagnosisDate,
        pastTreatments,
        hospitalVisitLocation,
        veterinaryDoctorName,
        medicinesPrescribed,
        recoveryStatus,
        medicalNotes,
      ];
}

/// Vaccination Record Item
class VaccinationRecordModel extends Equatable {
  final String id;
  final String livestockId;
  final String vaccineName; // FMD, HS, BQ, Brucellosis, Anthrax, PPR
  final String vaccinationDate;
  final String nextDueDate;
  final String vaccinatedBy;
  final String certificatePath;
  final bool isReminderActive;
  final bool isCompleted;

  const VaccinationRecordModel({
    required this.id,
    required this.livestockId,
    required this.vaccineName,
    required this.vaccinationDate,
    required this.nextDueDate,
    required this.vaccinatedBy,
    this.certificatePath = '',
    this.isReminderActive = true,
    this.isCompleted = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'livestock_id': livestockId,
        'vaccine_name': vaccineName,
        'vaccination_date': vaccinationDate,
        'next_due_date': nextDueDate,
        'vaccinated_by': vaccinatedBy,
        'certificate_path': certificatePath,
        'is_reminder_active': isReminderActive,
        'is_completed': isCompleted,
      };

  factory VaccinationRecordModel.fromJson(Map<String, dynamic> json) => VaccinationRecordModel(
        id: json['id'] ?? '',
        livestockId: json['livestock_id'] ?? '',
        vaccineName: json['vaccine_name'] ?? 'FMD Quadrivalent Vaccine',
        vaccinationDate: json['vaccination_date'] ?? '2024-02-01',
        nextDueDate: json['next_due_date'] ?? '2024-08-01',
        vaccinatedBy: json['vaccinated_by'] ?? 'Govt Vet Officer Dr. Rajesh',
        certificatePath: json['certificate_path'] ?? '',
        isReminderActive: json['is_reminder_active'] ?? true,
        isCompleted: json['is_completed'] ?? true,
      );

  @override
  List<Object?> get props => [
        id,
        livestockId,
        vaccineName,
        vaccinationDate,
        nextDueDate,
        vaccinatedBy,
        certificatePath,
        isReminderActive,
        isCompleted,
      ];
}
