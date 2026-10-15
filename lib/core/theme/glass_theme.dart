import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// Glassmorphism Styling System for AgriTech Dashboard Cards
class GlassTheme {
  GlassTheme._();

  static BoxDecoration glassDecoration({
    required bool isDark,
    double borderRadius = AppSpacing.radiusMd,
    Color? customColor,
    Border? customBorder,
  }) {
    return BoxDecoration(
      color: customColor ??
          (isDark ? AppColors.glassDark : AppColors.glassLight),
      borderRadius: BorderRadius.circular(borderRadius),
      border: customBorder ??
          Border.all(
            color: isDark ? AppColors.glassBorderDark : AppColors.glassBorderLight,
            width: 1.2,
          ),
      boxShadow: [
        BoxShadow(
          color: isDark ? AppColors.shadowDark : AppColors.shadow,
          blurRadius: 16,
          spreadRadius: 2,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}
