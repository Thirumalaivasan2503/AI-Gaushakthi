import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';

/// Loading State Indicator Widget
class LoadingWidget extends StatelessWidget {
  final String message;

  const LoadingWidget({
    super.key,
    this.message = 'Analyzing livestock breed metrics...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3.5,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.primary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
