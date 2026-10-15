import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';

/// Reusable Glassmorphic & Card-based Login Container Widget
class LoginCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const LoginCard({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: padding ?? AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: isDark ? AppColors.glassDark : AppColors.glassLight,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(
          color: isDark ? AppColors.glassBorderDark : AppColors.border,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
