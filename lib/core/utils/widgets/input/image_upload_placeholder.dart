import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';

/// Cattle Image / Health Scan Upload Placeholder Widget
class ImageUploadPlaceholder extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ImageUploadPlaceholder({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_a_photo, size: 36, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(title, style: AppTypography.titleMedium.copyWith(color: AppColors.primary)),
            Text('Tap to capture or upload cattle image', style: AppTypography.labelSmall),
          ],
        ),
      ),
    );
  }
}
