import '../models/consultation_model.dart';
import '../models/disease_model.dart';
import '../models/vet_report_review_model.dart';

abstract class VetRepository {
  Future<List<ConsultationModel>> getConsultations();
  Future<void> addConsultation(ConsultationModel consultation);
  
  Future<List<VetReportReviewModel>> getPendingReports();
  Future<void> reviewReport(String reportId, VetReportReviewModel updatedReport);

  Future<List<DiseaseModel>> getDiseases();
  Future<void> toggleBookmarkDisease(String diseaseId);
}
