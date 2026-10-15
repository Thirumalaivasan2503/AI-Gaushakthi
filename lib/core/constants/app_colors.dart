import 'package:flutter/material.dart';

/// Design System Color Palette for Indigenous Livestock AgriTech Platform
class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primary = Color(0xFF1B5E20); // Forest Green
  static const Color primaryLight = Color(0xFF4C8C4A);
  static const Color primaryDark = Color(0xFF003300);

  // Secondary Brand Colors
  static const Color secondary = Color(0xFFC9A227); // Elegant Gold
  static const Color secondaryLight = Color(0xFFFDD85D);
  static const Color secondaryDark = Color(0xFF967400);
  static const Color goldGlow = Color(0xFFFFF8E1);

  // Accent Colors
  static const Color accent = Color(0xFF43A047); // Leaf Green
  static const Color accentLight = Color(0xFF76D275);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF8F9F4); // Warm White
  static const Color backgroundDark = Color(0xFF121B14); // Deep Dark Forest
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E2A20);

  // Card Surfaces & Transparency
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF243327);
  static const Color glassLight = Color(0xCCFFFFFF); // 80% opacity
  static const Color glassDark = Color(0xCC1E2A20);
  static const Color glassBorderLight = Color(0x40FFFFFF);
  static const Color glassBorderDark = Color(0x3343A047);

  // Typography / Text Colors
  static const Color textPrimary = Color(0xFF263238); // Dark Blue Grey
  static const Color textSecondary = Color(0xFF607D8B); // Cool Grey
  static const Color textLight = Color(0xFFF8F9F4);
  static const Color textMuted = Color(0xFF90A4AE);

  // Dark Theme Text Overrides
  static const Color darkTextPrimary = Color(0xFFECEFF1);
  static const Color darkTextSecondary = Color(0xFFB0BEC5);

  // Functional Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF4FC3F7);

  // Neutral Grays & Dividers
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF2C3E30);
  static const Color shadow = Color(0x14000000);
  static const Color shadowDark = Color(0x40000000);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF2E7D32)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [secondary, Color(0xFFE5C158)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradientLight = LinearGradient(
    colors: [Color(0xF5FFFFFF), Color(0xD9F8F9F4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
