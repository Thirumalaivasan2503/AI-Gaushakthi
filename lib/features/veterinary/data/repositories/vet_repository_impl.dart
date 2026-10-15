import '../../../../core/services/api_service.dart';
import '../../domain/models/consultation_model.dart';
import '../../domain/models/disease_model.dart';
import '../../domain/models/vet_report_review_model.dart';
import '../../domain/repositories/vet_repository.dart';

class VetRepositoryImpl implements VetRepository {
  final ApiService apiService;

  final List<ConsultationModel> _consultations = [];
  final List<VetReportReviewModel> _pendingReports = [];
  final List<DiseaseModel> _diseases = [];

  VetRepositoryImpl({required this.apiService}) {
    _initSeedData();
  }

  void _initSeedData() {
    _consultations.addAll([
      const ConsultationModel(
        id: 'apt_101',
        farmerName: 'Ramesh Kumar',
        farmerMobile: '+91 98765 43210',
        animalTag: 'KANG-01',
        breed: 'Kangayam Cattle',
        type: ConsultationType.video,
        appointmentSlot: 'Today 04:00 PM',
        status: ConsultationStatus.scheduled,
      ),
      const ConsultationModel(
        id: 'apt_102',
        farmerName: 'Sundareshan M',
        farmerMobile: '+91 97700 12345',
        animalTag: 'SAHI-02',
        breed: 'Sahiwal Cow',
        type: ConsultationType.chat,
        appointmentSlot: 'Today 05:30 PM',
        status: ConsultationStatus.scheduled,
      ),
    ]);

    _pendingReports.addAll([
      const VetReportReviewModel(
        id: 'rep_901',
        farmerName: 'Ramesh Kumar',
        animalTag: 'BARG-03',
        breed: 'Bargur Cattle',
        submittedDate: 'Today 09:30 AM',
        clinicalObservations: 'Animal showing mild fever (103.2°F), nasal discharge, and reduced appetite.',
        imageUrls: [
          'https://storage.googleapis.com/pasumitra-ai-bucket/reports/bargur_cow.jpg',
        ],
        pdfReportUrl: 'https://storage.googleapis.com/pasumitra-ai-bucket/reports/vet_scan_901.pdf',
        assignedSeverity: 'Medium',
      ),
    ]);

    _diseases.addAll([
      const DiseaseModel(
        id: 'dis_1',
        name: 'Foot and Mouth Disease (FMD)',
        symptoms: ['High Fever (104-106°F)', 'Blisters on Hooves and Tongue', 'Excess Salivation', 'Lame Walk'],
        causes: 'Aphthovirus (Picornaviridae family)',
        severity: 'Critical / Emergency',
        treatment: 'Antiseptic foot bath using 1% KMnO4, Oxytetracycline spray, B-complex injections.',
        medicine: 'Potassium Permanganate, Oxytetracycline, Meloxicam',
        recoveryPeriod: '14 - 21 Days',
        vaccinationInfo: 'FMD Quadrivalent Vaccine administered bi-annually',
        isolationRecommendation: 'Strictly isolate infected livestock in a dry shaded shed away from the herd for 21 days.',
        isEmergency: true,
        governmentAdvisory: 'Mandatory ring vaccination active across district under Rashtriya Gokul Mission.',
      ),
      const DiseaseModel(
        id: 'dis_2',
        name: 'Lumpy Skin Disease (LSD)',
        symptoms: ['Fever', 'Nodular Skin Lesions across Body', 'Swollen Lymph Nodes', 'Edema in Legs'],
        causes: 'Capripoxvirus (Vector transmitted via flies & ticks)',
        severity: 'High',
        treatment: 'Symptomatic treatment, Neem & Turmeric paste application, anti-inflammatory support.',
        medicine: 'Ivermectin, Paracetamol, Topical Herbal Antiseptic',
        recoveryPeriod: '21 - 30 Days',
        vaccinationInfo: 'Goat Pox Vaccine (Cross-protection) administered annually',
        isolationRecommendation: 'Isolate animal and spray fly repellents across shed premises.',
        isEmergency: true,
        governmentAdvisory: 'Report nodular outbreaks to Nearest Veterinary Hospital immediately.',
      ),
      const DiseaseModel(
        id: 'dis_3',
        name: 'Peste des Petits Ruminants (PPR Goat Plague)',
        symptoms: ['High Fever', 'Foul Nasal & Ocular Discharge', 'Severe Diarrhea', 'Mouth Ulcers'],
        causes: 'Morbillivirus Infection in Goats/Sheep',
        severity: 'Critical / Emergency',
        treatment: 'Supportive fluid therapy, broad spectrum antibiotics to prevent secondary bacterial infection.',
        medicine: 'ORS Electrolytes, Enrofloxacin, Multivitamins',
        recoveryPeriod: '10 - 14 Days',
        vaccinationInfo: 'PPR Vaccine (Single dose provides lifetime immunity)',
        isolationRecommendation: 'Isolate affected goats immediately and disinfect feeding troughs with lime wash.',
        isEmergency: true,
        governmentAdvisory: 'National PPR Eradication Programme active.',
      ),
    ]);
  }

  @override
  Future<List<ConsultationModel>> getConsultations() async {
    return List.unmodifiable(_consultations);
  }

  @override
  Future<void> addConsultation(ConsultationModel consultation) async {
    _consultations.insert(0, consultation);
  }

  @override
  Future<List<VetReportReviewModel>> getPendingReports() async {
    return List.unmodifiable(_pendingReports);
  }

  @override
  Future<void> reviewReport(String reportId, VetReportReviewModel updatedReport) async {
    final idx = _pendingReports.indexWhere((r) => r.id == reportId);
    if (idx != -1) {
      _pendingReports[idx] = updatedReport;
    }
  }

  @override
  Future<List<DiseaseModel>> getDiseases() async {
    return List.unmodifiable(_diseases);
  }

  @override
  Future<void> toggleBookmarkDisease(String diseaseId) async {
    final idx = _diseases.indexWhere((d) => d.id == diseaseId);
    if (idx != -1) {
      final current = _diseases[idx];
      _diseases[idx] = current.copyWith(isBookmarked: !current.isBookmarked);
    }
  }
}
