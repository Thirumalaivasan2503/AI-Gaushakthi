import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/buttons/primary_button.dart';

/// Language Selection Screen (English, Tamil, Hindi)
class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = AppStrings.english;

  final List<Map<String, String>> _languages = [
    {'name': AppStrings.english, 'native': 'English', 'code': 'en'},
    {'name': AppStrings.tamil, 'native': 'தமிழ்', 'code': 'ta'},
    {'name': AppStrings.hindi, 'native': 'हिंदी', 'code': 'hi'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Language'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Preferred Vernacular Language', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text(
                'Select your language for AI breed advice, health alerts, and localized voice prompts.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.separated(
                  itemCount: _languages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final lang = _languages[index];
                    final isSelected = _selectedLanguage == lang['name'];

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedLanguage = lang['name']!;
                        });
                      },
                      borderRadius: AppSpacing.borderRadiusMd,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.08)
                              : Theme.of(context).cardColor,
                          borderRadius: AppSpacing.borderRadiusMd,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.border,
                            width: isSelected ? 2.0 : 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang['native']!,
                                  style: AppTypography.titleLarge.copyWith(
                                    fontSize: 18,
                                    color: isSelected ? AppColors.primary : null,
                                  ),
                                ),
                                Text(lang['name']!, style: AppTypography.bodySmall),
                              ],
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: AppColors.primary, size: 24),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              PrimaryButton(
                text: 'Confirm & Proceed to Login',
                onPressed: () {
                  context.push('/auth/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
