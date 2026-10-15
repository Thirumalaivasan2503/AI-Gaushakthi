import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/cards/glass_card.dart';

/// Notifications & Vaccination Alert Screen
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts & Reminders'),
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.paddingMd,
          children: [
            _buildNotificationItem(
              title: 'Vaccination Alert: FMD Booster',
              message: 'Scheduled for 3 Sahiwal & 2 Kangayam cattle on August 15.',
              time: '2 hours ago',
              icon: Icons.vaccines,
              color: AppColors.warning,
            ),
            const SizedBox(height: 12),
            _buildNotificationItem(
              title: 'Heat Wave Warning (42°C)',
              message: 'Ensure shade and electrolyte water for lactating Gir cows.',
              time: 'Yesterday',
              icon: Icons.wb_sunny,
              color: AppColors.error,
            ),
            const SizedBox(height: 12),
            _buildNotificationItem(
              title: 'New Breed AI Model Sync Completed',
              message: 'Updated genetic suitability metrics for Jamnapari goats.',
              time: '3 days ago',
              icon: Icons.auto_awesome,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String message,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium),
                const SizedBox(height: 4),
                Text(message, style: AppTypography.bodySmall),
                const SizedBox(height: 6),
                Text(time, style: AppTypography.labelSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
