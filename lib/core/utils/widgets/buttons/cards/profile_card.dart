import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';
import 'glass_card.dart';

/// User Profile Info Card Widget
class ProfileCard extends StatelessWidget {
  final String userName;
  final String role;
  final String emailOrPhone;
  final VoidCallback? onEdit;

  const ProfileCard({
    super.key,
    required this.userName,
    required this.role,
    required this.emailOrPhone,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primary,
            child: Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
              style: AppTypography.headlineLarge.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: AppTypography.titleLarge),
                const SizedBox(height: 2),
                Text(
                  role,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.secondaryDark),
                ),
                const SizedBox(height: 2),
                Text(emailOrPhone, style: AppTypography.labelSmall),
              ],
            ),
          ),
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.primary),
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }
}
