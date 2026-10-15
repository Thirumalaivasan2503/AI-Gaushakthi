import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';

/// Reusable Language Picker Component (English, Hindi, Tamil, Telugu, Kannada, etc.)
class LanguagePickerWidget extends StatelessWidget {
  final String currentLanguageCode;
  final ValueChanged<String> onLanguageChanged;

  const LanguagePickerWidget({
    super.key,
    required this.currentLanguageCode,
    required this.onLanguageChanged,
  });

  static const List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English', 'native': 'English'},
    {'code': 'hi', 'name': 'Hindi', 'native': 'हिन्दी'},
    {'code': 'ta', 'name': 'Tamil', 'native': 'தமிழ்'},
    {'code': 'te', 'name': 'Telugu', 'native': 'తెలుగు'},
    {'code': 'kn', 'name': 'Kannada', 'native': 'கன்னட'},
    {'code': 'mr', 'name': 'Marathi', 'native': 'मराठी'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentLanguageCode,
          icon: const Icon(Icons.language, color: AppColors.primary, size: 18),
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          onChanged: (code) {
            if (code != null) onLanguageChanged(code);
          },
          items: languages.map((lang) {
            return DropdownMenuItem<String>(
              value: lang['code'],
              child: Text(
                '${lang['native']} (${lang['name']})',
                style: AppTypography.bodySmall,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
