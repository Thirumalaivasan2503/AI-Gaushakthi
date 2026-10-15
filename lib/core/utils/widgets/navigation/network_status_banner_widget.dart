import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';

/// Network Connectivity Status Banner
class NetworkStatusBannerWidget extends StatelessWidget {
  final bool isOnline;

  const NetworkStatusBannerWidget({
    super.key,
    this.isOnline = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isOnline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: AppColors.warning,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            'Offline Mode • Local SQLite Cache Active',
            style: AppTypography.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
