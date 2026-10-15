import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../domain/user_role.dart';

/// Role Selection Screen (Farmer, Vet Expert, Admin)
class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole _selectedRole = UserRole.ruralFarmer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Persona'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How will you be using PasuMitra AI?',
                style: AppTypography.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'We tailor indigenous breed models and insights to your specific farming background.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: UserRole.values.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final role = UserRole.values[index];
                    final isSelected = _selectedRole == role;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedRole = role;
                        });
                      },
                      borderRadius: AppSpacing.borderRadiusMd,
                      child: Container(
                        padding: const EdgeInsets.all(20),
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
                          children: [
                            Icon(
                              _getRoleIcon(role),
                              color: isSelected ? AppColors.primary : AppColors.textSecondary,
                              size: 28,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    role.title,
                                    style: AppTypography.titleLarge.copyWith(
                                      color: isSelected ? AppColors.primary : null,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(role.description, style: AppTypography.bodySmall),
                                ],
                              ),
                            ),
                            Radio<UserRole>(
                              value: role,
                              groupValue: _selectedRole,
                              activeColor: AppColors.primary,
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _selectedRole = val;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              PrimaryButton(
                text: 'Continue to Language Selection',
                onPressed: () {
                  context.push('/auth/language');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.ruralFarmer:
        return Icons.agriculture;
      case UserRole.urbanFarmer:
        return Icons.storefront;
      case UserRole.veterinaryExpert:
        return Icons.medical_services;
      case UserRole.administrator:
        return Icons.admin_panel_settings;
    }
  }
}
