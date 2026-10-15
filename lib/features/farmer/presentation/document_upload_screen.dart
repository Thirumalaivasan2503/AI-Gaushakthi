import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/cards/login_card.dart';
import '../../../core/widgets/cards/upload_card.dart';
import '../../../core/widgets/feedback/loading_overlay.dart';
import '../../../core/widgets/input/custom_dropdown.dart';
import '../../../core/widgets/input/custom_text_field.dart';

import '../domain/models/document_upload_model.dart';
import 'controllers/farmer_controller.dart';

/// Document Upload Hub & File Manager Screen
class DocumentUploadScreen extends ConsumerStatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  ConsumerState<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends ConsumerState<DocumentUploadScreen> {
  final _titleController = TextEditingController(text: 'Annual FMD Vaccination Certificate');
  DocumentCategory _selectedCategory = DocumentCategory.vaccinationCertificate;
  DocumentFormat _selectedFormat = DocumentFormat.pdf;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _simulateUpload() async {
    if (_titleController.text.isNotEmpty) {
      setState(() {
        _isUploading = true;
        _uploadProgress = 10.0;
      });

      for (int i = 2; i <= 10; i++) {
        await Future.delayed(const Duration(milliseconds: 150));
        if (mounted) {
          setState(() {
            _uploadProgress = i * 10.0;
          });
        }
      }

      final docPath = _selectedFormat == DocumentFormat.pdf
          ? 'certificates/${_titleController.text.toLowerCase().replaceAll(' ', '_')}.pdf'
          : 'images/${_titleController.text.toLowerCase().replaceAll(' ', '_')}.jpg';

      await ref.read(farmerControllerProvider.notifier).uploadDocument(
            title: _titleController.text.trim(),
            category: _selectedCategory,
            filePath: docPath,
            format: _selectedFormat,
          );

      if (mounted) {
        setState(() {
          _isUploading = false;
          _uploadProgress = 0.0;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Document uploaded and stored in offline sync queue!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final farmerState = ref.watch(farmerControllerProvider);
    final documents = farmerState.uploadedDocuments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Upload Hub'),
      ),
      body: LoadingOverlay(
        isLoading: farmerState.isLoading,
        message: 'Processing file upload...',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Farm & Vet Document Vault', style: AppTypography.displayMedium.copyWith(color: AppColors.primary)),
                const SizedBox(height: 8),
                Text('Upload veterinary reports, vaccination certificates, purchase invoices, and animal photos (PDF, JPEG, PNG).', style: AppTypography.bodyMedium),
                const SizedBox(height: 24),

                // Upload Box
                LoginCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Upload New Document', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Document Title / Description',
                        hint: 'FMD Vaccination Certificate 2024',
                        controller: _titleController,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: CustomDropdown<DocumentCategory>(
                              label: 'Category',
                              value: _selectedCategory,
                              items: DocumentCategory.values.map((c) {
                                return DropdownMenuItem(value: c, child: Text(c.label));
                              }).toList(),
                              onChanged: (val) => setState(() => _selectedCategory = val!),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomDropdown<DocumentFormat>(
                              label: 'File Format',
                              value: _selectedFormat,
                              items: const [
                                DropdownMenuItem(value: DocumentFormat.pdf, child: Text('PDF Document')),
                                DropdownMenuItem(value: DocumentFormat.jpeg, child: Text('JPEG Image')),
                                DropdownMenuItem(value: DocumentFormat.png, child: Text('PNG Image')),
                              ],
                              onChanged: (val) => setState(() => _selectedFormat = val!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Drag & Drop Area Placeholder
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary.withOpacity(0.3), style: BorderStyle.solid),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.cloud_upload_outlined, size: 40, color: AppColors.primary),
                            const SizedBox(height: 8),
                            Text('Tap to select PDF, JPEG, or PNG file', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                            Text('Maximum file size: 10 MB', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (_isUploading) ...[
                        Text('Uploading... ${_uploadProgress.toStringAsFixed(0)}%', style: AppTypography.labelSmall),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: _uploadProgress / 100.0,
                          backgroundColor: AppColors.border,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                        ),
                        const SizedBox(height: 16),
                      ],

                      PrimaryButton(
                        text: 'Upload File',
                        onPressed: _isUploading ? null : _simulateUpload,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),
                // Vault Items List
                Text('Uploaded Vault Documents (${documents.length})', style: AppTypography.titleLarge),
                const SizedBox(height: 12),

                if (documents.isEmpty) ...[
                  const Center(child: Text('No documents uploaded yet.')),
                ] else ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final doc = documents[index];
                      return UploadCardWidget(document: doc);
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
