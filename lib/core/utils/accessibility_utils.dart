import 'package:flutter/material.dart';

/// Accessibility Utilities for Large Fonts, Easy Touch Targets, and High Contrast
class AccessibilityUtils {
  AccessibilityUtils._();

  static double getClampedTextScale(BuildContext context, {double maxScale = 1.4}) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.textScaleFactor.clamp(1.0, maxScale);
  }

  static bool isHighContrastEnabled(BuildContext context) {
    return MediaQuery.of(context).highContrast;
  }

  static Widget ensureMinTouchTarget({required Widget child, double minSize = 48.0}) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minSize,
        minHeight: minSize,
      ),
      child: Center(child: child),
    );
  }
}
