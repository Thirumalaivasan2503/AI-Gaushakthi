import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';

/// Network Status Banner & Offline Login Banner Components
class NetworkStatusBannerWidget extends StatelessWidget {
  final bool isOnline;

  const NetworkStatusBannerWidget({
    super.key,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    if (isOnline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: AppColors.warning.withOpacity(0.9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            'You are offline. Features may run in cached mode.',
            style: AppTypography.labelMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class OfflineLoginBannerWidget extends StatelessWidget {
  final VoidCallback? onSyncTap;

  const OfflineLoginBannerWidget({
    super.key,
    this.onSyncTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.offline_pin, color: AppColors.secondary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offline Session Active',
                  style: AppTypography.titleSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Logged in using cached local SQLite credentials.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          if (onSyncTap != null)
            TextButton(
              onPressed: onSyncTap,
              child: Text(
                'Sync',
                style: AppTypography.labelSmall.copyWith(color: AppColors.secondary),
              ),
            ),
        ],
      ),
    );
  }
}
