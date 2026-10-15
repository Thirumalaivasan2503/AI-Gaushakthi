import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';

/// Offline Sync Pending Banner Component
class OfflineBanner extends StatelessWidget {
  final VoidCallback? onSyncTap;

  const OfflineBanner({super.key, this.onSyncTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary),
      ),
      child: Row(
        children: [
          const Icon(Icons.sync_problem, color: AppColors.secondaryDark),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sync Pending', style: AppTypography.titleMedium.copyWith(color: AppColors.secondaryDark)),
                Text('3 Offline breed queries will sync when connected.', style: AppTypography.labelSmall),
              ],
            ),
          ),
          if (onSyncTap != null)
            TextButton(
              onPressed: onSyncTap,
              child: Text('SYNC NOW', style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
            ),
        ],
      ),
    );
  }
}
