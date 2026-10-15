import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_typography.dart';
import '../../../features/authentication/domain/user_role.dart';

/// Reusable Role Selection Cards (Farmer, Veterinary Expert, Administrator)
class RoleSelectorWidget extends StatelessWidget {
  final UserRole selectedRole;
  final ValueChanged<UserRole> onRoleSelected;

  const RoleSelectorWidget({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    final roles = [
      UserRole.ruralFarmer,
      UserRole.veterinaryExpert,
      UserRole.administrator,
    ];

    return Column(
      children: roles.map((role) {
        final isSelected = selectedRole == role;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: InkWell(
            onTap: () => onRoleSelected(role),
            borderRadius: AppSpacing.borderRadiusMd,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.08)
                    : Theme.of(context).cardColor,
                borderRadius: AppSpacing.borderRadiusMd,
                border: Border.all(
                  color: isSelected ? AppColors.secondary : AppColors.border,
                  width: isSelected ? 2.0 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getRoleIcon(role),
                      color: isSelected ? Colors.white : AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          role.title,
                          style: AppTypography.titleMedium.copyWith(
                            color: isSelected ? AppColors.primary : null,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          role.description,
                          style: AppTypography.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Radio<UserRole>(
                    value: role,
                    groupValue: selectedRole,
                    activeColor: AppColors.secondary,
                    onChanged: (val) {
                      if (val != null) onRoleSelected(val);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.ruralFarmer:
      case UserRole.urbanFarmer:
        return Icons.agriculture;
      case UserRole.veterinaryExpert:
        return Icons.medical_services;
      case UserRole.administrator:
        return Icons.admin_panel_settings;
    }
  }
}
