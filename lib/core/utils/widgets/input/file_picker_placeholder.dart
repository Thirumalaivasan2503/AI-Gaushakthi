import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';

/// Document / File Upload Container Component Placeholder
class FilePickerPlaceholder extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const FilePickerPlaceholder({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.picture_as_pdf, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(label, style: AppTypography.titleMedium.copyWith(color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}
