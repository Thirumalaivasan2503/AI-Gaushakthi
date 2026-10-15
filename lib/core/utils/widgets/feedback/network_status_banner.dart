import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';
import '../../services/network_info_service.dart';

/// Interactive Network Status Banner Widget
class NetworkStatusBanner extends ConsumerWidget {
  const NetworkStatusBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);

    if (isOnline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: AppColors.warning,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 18, color: AppColors.textPrimary),
          const SizedBox(width: 8),
          Text(
            'Offline Mode active. Cached recommendations displayed.',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => ref.read(isOnlineProvider.notifier).setOnlineStatus(true),
            child: Text(
              'RETRY',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w900,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
