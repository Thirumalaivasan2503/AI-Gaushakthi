import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/cards/login_card.dart';
import '../../../core/widgets/feedback/loading_overlay.dart';
import '../../../core/widgets/input/custom_dropdown.dart';
import '../../../core/widgets/input/custom_text_field.dart';

import '../domain/models/vet_report_review_model.dart';
import 'controllers/vet_controller.dart';

/// Veterinary Report Review Workspace (Image Zoom & PDF Support)
class VetReportReviewScreen extends ConsumerStatefulWidget {
  const VetReportReviewScreen({super.key});

  @override
  ConsumerState<VetReportReviewScreen> createState() => _VetReportReviewScreenState();
}

class _VetReportReviewScreenState extends ConsumerState<VetReportReviewScreen> {
  final _commentsController = TextEditingController(text: 'Observed early stage fever symptoms. Administered oral hydration.');
  final _treatmentController = TextEditingController(text: 'Potassium Permanganate 1% antiseptic wash daily.');
  final _vaccineController = TextEditingController(text: 'FMD Booster recommended after recovery.');
  String _assignedSeverity = 'Medium';

  @override
  void dispose() {
    _commentsController.dispose();
    _treatmentController.dispose();
    _vaccineController.dispose();
    super.dispose();
  }

  void _showImageZoomModal(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black87,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text('Uploaded Clinical Photo (Pinch to Zoom)', style: TextStyle(color: Colors.white, fontSize: 14)),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Container(
                padding: const EdgeInsets.all(16),
                height: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://storage.googleapis.com/pasumitra-ai-bucket/reports/bargur_cow.jpg'),
                    fit: BoxFit.contain,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.pets, size: 80, color: Colors.white54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitReview(VetReportReviewModel report, ReviewStatus status) async {
    final updated = report.copyWith(
      status: status,
      assignedSeverity: _assignedSeverity,
      vetComments: _commentsController.text.trim(),
      recommendedTreatment: _treatmentController.text.trim(),
      recommendedVaccines: _vaccineController.text.trim(),
    );

    await ref.read(vetControllerProvider.notifier).reviewReport(report.id, updated);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report review saved with status: ${status.name.toUpperCase()}')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final vetState = ref.watch(vetControllerProvider);
    final reports = vetState.pendingReports;

    if (reports.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Farmer Report Review')),
        body: const Center(child: Text('No pending farmer reports for review.')),
      );
    }

    final report = reports.first;

    return Scaffold(
      appBar: AppBar(
        title: Text('Review: ${report.animalTag} (${report.farmerName})'),
      ),
      body: LoadingOverlay(
        isLoading: vetState.isLoading,
        message: 'Saving clinical consultation notes...',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Farmer Clinical Report Workspace', style: AppTypography.displayMedium.copyWith(color: AppColors.primary)),
                const SizedBox(height: 8),
                Text('Review uploaded clinical images, laboratory PDFs, and prescribe treatments.', style: AppTypography.bodyMedium),
                const SizedBox(height: 24),

                // Report Details Card
                LoginCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Submitted by: ${report.farmerName}', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                          Text(report.submittedDate, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Animal Tag: ${report.animalTag} (${report.breed})', style: AppTypography.bodySmall.copyWith(color: AppColors.primary)),
                      const SizedBox(height: 12),
                      Text('Clinical Observations:', style: AppTypography.titleSmall),
                      Text(report.clinicalObservations, style: AppTypography.bodySmall),
                      const SizedBox(height: 16),

                      // Image preview button
                      Text('Uploaded Media & Scans:', style: AppTypography.titleSmall),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                            onPressed: () => _showImageZoomModal(context, ''),
                            icon: const Icon(Icons.zoom_in, color: Colors.white, size: 18),
                            label: const Text('View / Zoom Photo', style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Opening PDF lab report preview...')),
                              );
                            },
                            icon: const Icon(Icons.picture_as_pdf, color: AppColors.error, size: 18),
                            label: const Text('Open PDF Scan'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                // Diagnosis & Prescription Form
                LoginCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Veterinary Assessment & Prescription', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),

                      CustomDropdown<String>(
                        label: 'Assign Disease Severity',
                        value: _assignedSeverity,
                        items: const [
                          DropdownMenuItem(value: 'Low', child: Text('Low Severity')),
                          DropdownMenuItem(value: 'Medium', child: Text('Medium Severity')),
                          DropdownMenuItem(value: 'High', child: Text('High Severity')),
                          DropdownMenuItem(value: 'Emergency', child: Text('Critical / Emergency')),
                        ],
                        onChanged: (val) => setState(() => _assignedSeverity = val!),
                      ),
                      const SizedBox(height: 12),

                      CustomTextField(
                        label: 'Veterinary Comments / Consultation Notes',
                        controller: _commentsController,
                      ),
                      const SizedBox(height: 12),

                      CustomTextField(
                        label: 'Recommended Treatment & Medicines',
                        controller: _treatmentController,
                      ),
                      const SizedBox(height: 12),

                      CustomTextField(
                        label: 'Recommended Vaccination Schedule',
                        controller: _vaccineController,
                      ),
                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                              onPressed: () => _submitReview(report, ReviewStatus.approved),
                              child: const Text('Approve & Send', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
                              onPressed: () => _submitReview(report, ReviewStatus.rejected),
                              child: const Text('Reject Report'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
