import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/cards/glass_card.dart';
import '../../../core/widgets/input/image_upload_placeholder.dart';

/// Veterinary Telehealth & Disease Assistance Screen
class VetTelemetryScreen extends StatelessWidget {
  const VetTelemetryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veterinary Expert Portal'),
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.paddingMd,
          children: [
            GlassCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.accent.withOpacity(0.2),
                    child: const Icon(Icons.medical_services, color: AppColors.accent, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dr. Anita Sundaram, DVM', style: AppTypography.titleLarge),
                        Text('Senior Indigenous Animal Geneticist', style: AppTypography.bodySmall),
                        Text('Available for Tele-Consultation', style: AppTypography.labelSmall.copyWith(color: AppColors.success)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Scan Animal Symptoms', style: AppTypography.titleLarge),
            const SizedBox(height: 8),
            ImageUploadPlaceholder(
              title: 'Upload Cattle Symptom / Eye / Skin Photo',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Camera scanner ready for cattle symptom upload.')),
                );
              },
            ),
            const SizedBox(height: 24),
            Text('Quick Vet Actions', style: AppTypography.titleLarge),
            const SizedBox(height: 12),
            PrimaryButton(
              text: 'Book Video Consultation',
              icon: Icons.video_call,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
