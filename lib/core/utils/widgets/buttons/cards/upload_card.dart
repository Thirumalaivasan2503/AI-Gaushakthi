import 'package:flutter/material.dart';
import '../../../features/farmer/domain/models/document_upload_model.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';

/// Reusable Upload Card & Progress Widget
class UploadCardWidget extends StatelessWidget {
  final DocumentUploadModel document;
  final VoidCallback? onDeleteTap;

  const UploadCardWidget({
    super.key,
    required this.document,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _getFormatColor(document.format).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getFormatIcon(document.format),
              color: _getFormatColor(document.format),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.title,
                  style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${document.category.label} • ${document.fileName}',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 6),
                if (document.status == UploadStatus.uploading) ...[
                  LinearProgressIndicator(
                    value: document.progressPercentage / 100.0,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                  ),
                ] else ...[
                  Text(
                    'Uploaded: ${document.uploadTimestamp}',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.success),
                  ),
                ],
              ],
            ),
          ),
          if (onDeleteTap != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
              onPressed: onDeleteTap,
            ),
        ],
      ),
    );
  }

  IconData _getFormatIcon(DocumentFormat format) {
    switch (format) {
      case DocumentFormat.pdf:
        return Icons.picture_as_pdf;
      case DocumentFormat.jpeg:
      case DocumentFormat.png:
        return Icons.image;
    }
  }

  Color _getFormatColor(DocumentFormat format) {
    switch (format) {
      case DocumentFormat.pdf:
        return AppColors.error;
      case DocumentFormat.jpeg:
      case DocumentFormat.png:
        return AppColors.primary;
    }
  }
}
