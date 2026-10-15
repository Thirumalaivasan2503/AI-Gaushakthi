import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/cards/login_card.dart';
import '../../../core/widgets/feedback/loading_overlay.dart';
import '../../../core/widgets/input/custom_text_field.dart';
import '../../../core/widgets/input/otp_input.dart';
import '../../../core/widgets/input/password_field.dart';
import '../domain/models/auth_state.dart';
import '../domain/utils/validators.dart';
import 'controllers/auth_controller.dart';

/// Forgot & Reset Password Flow Screen
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identityController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  int _currentStep = 1; // 1: Enter email/mobile, 2: Enter OTP & New Password
  String _otpValue = '';

  @override
  void dispose() {
    _identityController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _sendResetCode() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(authControllerProvider.notifier).forgotPassword(_identityController.text.trim());
      setState(() {
        _currentStep = 2;
      });
    }
  }

  void _submitNewPassword() async {
    if (_otpValue.length == 6 && (_formKey.currentState?.validate() ?? false)) {
      await ref.read(authControllerProvider.notifier).resetPassword(
            _identityController.text.trim(),
            _otpValue,
            _newPasswordController.text,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successfully! Please log in.')),
        );
        context.go('/auth/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: LoadingOverlay(
        isLoading: authState.status == AuthStatus.loading,
        message: _currentStep == 1 ? 'Sending security code...' : 'Updating password...',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLg,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Password Recovery', style: AppTypography.displayMedium.copyWith(color: AppColors.primary)),
                  const SizedBox(height: 8),
                  Text(
                    _currentStep == 1
                        ? 'Enter your registered email address or mobile number to receive a reset code.'
                        : 'Enter the 6-digit PIN sent to your phone/email along with your new password.',
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: 28),

                  LoginCard(
                    child: _currentStep == 1
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                label: 'Email or Mobile Number',
                                hint: 'farmer@pasumitra.org or 9876543210',
                                controller: _identityController,
                                prefixIcon: Icons.perm_identity,
                                validator: (val) => Validators.validateRequired(val, 'Email or Mobile Number'),
                              ),
                              const SizedBox(height: 24),
                              PrimaryButton(
                                text: 'Send Reset Code',
                                onPressed: _sendResetCode,
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('6-Digit Verification PIN', style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              OtpInputWidget(
                                length: 6,
                                onCompleted: (otp) => setState(() => _otpValue = otp),
                                onChanged: (otp) => setState(() => _otpValue = otp),
                              ),
                              const SizedBox(height: 20),
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
                                text: 'Reset Password',
                                onPressed: _otpValue.length == 6 ? _submitNewPassword : null,
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
