import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_typography.dart';

/// Reusable Gradient CTA Accent Button
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final LinearGradient gradient;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.gradient = AppColors.goldGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.buttonHeight,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: AppSpacing.borderRadiusMd,
        boxShadow: const [
          BoxShadow(
            color: Color(0x33C9A227),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onPressed: onPressed,
          borderRadius: AppSpacing.borderRadiusMd,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: AppColors.textPrimary, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: AppTypography.buttonText.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
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
