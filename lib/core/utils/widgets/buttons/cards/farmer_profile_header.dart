import 'package:flutter/material.dart';
import '../../../features/farmer/domain/models/farmer_profile_model.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_typography.dart';

/// Reusable Farmer Profile Header Banner Component
class FarmerProfileHeaderWidget extends StatelessWidget {
  final FarmerProfileModel profile;
  final VoidCallback onEditTap;

  const FarmerProfileHeaderWidget({
    super.key,
    required this.profile,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppSpacing.borderRadiusLg,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.secondary,
            child: Text(
              profile.fullName.isNotEmpty ? profile.fullName[0].toUpperCase() : 'F',
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.fullName,
                  style: AppTypography.titleLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${profile.farmName} • ${profile.farmSizeAcres} Acres',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.secondaryLight),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(
                      '${profile.village}, ${profile.district}',
                      style: AppTypography.labelSmall.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_note, color: Colors.white, size: 28),
            onPressed: onEditTap,
          ),
        ],
      ),
    );
  }
}
