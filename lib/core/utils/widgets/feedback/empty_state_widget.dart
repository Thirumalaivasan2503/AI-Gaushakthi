import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';
import '../buttons/primary_button.dart';

/// Empty State Illustration & Action Widget
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.nature_people_outlined,
            size: 80,
            color: AppColors.primary.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(title, style: AppTypography.headlineMedium, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(message, style: AppTypography.bodyMedium, textAlign: TextAlign.center),
          if (buttonText != null && onAction != null) ...[
            const SizedBox(height: 24),
            PrimaryButton(
              text: buttonText!,
              onPressed: onAction,
              width: 200,
            ),
          ],
        ],
      ),
    );
  }
}
