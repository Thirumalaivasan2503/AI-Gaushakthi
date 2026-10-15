import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';

/// Error State Container Widget with Retry CTA
class CustomErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;

  const CustomErrorWidget({
    super.key,
    required this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 40, color: AppColors.error),
          const SizedBox(height: 12),
          Text('Something went wrong', style: AppTypography.titleLarge.copyWith(color: AppColors.error)),
          const SizedBox(height: 4),
          Text(errorMessage, style: AppTypography.bodySmall, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, color: AppColors.error),
              label: Text('Retry', style: AppTypography.buttonText.copyWith(color: AppColors.error)),
            ),
          ],
        ],
      ),
    );
  }
}
