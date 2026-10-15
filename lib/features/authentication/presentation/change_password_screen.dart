import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/cards/login_card.dart';
import '../../../core/widgets/feedback/loading_overlay.dart';
import '../../../core/widgets/input/password_field.dart';
import '../domain/utils/validators.dart';
import 'controllers/auth_controller.dart';

/// Change Password Screen for Authenticated Users
class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleChangePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final repo = ref.read(authRepositoryProvider);
        await repo.changePassword(
          oldPassword: _oldPasswordController.text,
          newPassword: _newPasswordController.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password changed successfully!')),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error changing password: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Update Security Credentials', style: AppTypography.displaySmall.copyWith(color: AppColors.primary)),
                const SizedBox(height: 8),
                Text(
                  'Enter your existing password followed by your new password.',
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: 24),
                LoginCard(
                  child: Column(
                    children: [
                      PasswordField(
                        label: 'Current Password',
                        controller: _oldPasswordController,
                        validator: Validators.validatePassword,
                      ),
                      const SizedBox(height: 16),
                      PasswordField(
                        label: 'New Password',
                        controller: _newPasswordController,
                        validator: Validators.validatePassword,
                      ),
                      const SizedBox(height: 16),
                      PasswordField(
                        label: 'Confirm New Password',
                        controller: _confirmPasswordController,
                        validator: (val) => Validators.validateConfirmPassword(
                          _newPasswordController.text,
                          val,
                        ),
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        text: 'Update Password',
                        onPressed: _handleChangePassword,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
