import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/cards/login_card.dart';
import '../../../core/widgets/feedback/loading_overlay.dart';
import '../../../core/widgets/input/otp_input.dart';
import '../domain/models/auth_state.dart';
import '../domain/user_role.dart';
import 'controllers/auth_controller.dart';

/// 6-digit Mobile OTP Verification Screen UI
class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  String _enteredOtp = '';
  int _secondsRemaining = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  void _verifyOtp() async {
    if (_enteredOtp.length == 6) {
      await ref.read(authControllerProvider.notifier).verifyOtp(
            widget.phoneNumber,
            _enteredOtp,
          );

      final authState = ref.read(authControllerProvider);
      if (authState.status == AuthStatus.authenticated && authState.user != null) {
        if (mounted) {
          _showSuccessModal(authState.user!.role);
        }
      }
    }
  }

  void _showSuccessModal(UserRole role) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 20),
            Text('Verification Successful!', style: AppTypography.titleLarge.copyWith(color: AppColors.primary)),
            const SizedBox(height: 8),
            Text(
              'Your mobile number has been authenticated. Redirecting to your dashboard...',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall,
            ),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        _navigateBasedOnRole(role);
      }
    });
  }

  void _navigateBasedOnRole(UserRole role) {
    switch (role) {
      case UserRole.veterinaryExpert:
        context.go('/vet-dashboard');
        break;
      case UserRole.administrator:
        context.go('/admin-dashboard');
        break;
      case UserRole.ruralFarmer:
      case UserRole.urbanFarmer:
      default:
        context.go('/home');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: LoadingOverlay(
        isLoading: authState.status == AuthStatus.loading,
        message: 'Verifying 6-digit PIN...',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Verify Phone Number', style: AppTypography.displayMedium.copyWith(color: AppColors.primary)),
                const SizedBox(height: 8),
                Text(
                  'We sent a 6-digit security verification code to ${widget.phoneNumber}',
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: 28),

                LoginCard(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.phonelink_lock, color: AppColors.secondary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Auto OTP Detection Listening...',
                            style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      OtpInputWidget(
                        length: 6,
                        onChanged: (otp) {
                          setState(() {
                            _enteredOtp = otp;
                          });
                        },
                        onCompleted: (otp) {
                          setState(() {
                            _enteredOtp = otp;
                          });
                          _verifyOtp();
                        },
                      ),
                      const SizedBox(height: 28),

                      PrimaryButton(
                        text: 'Verify PIN & Access Dashboard',
                        onPressed: _enteredOtp.length == 6 ? _verifyOtp : null,
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!_canResend) ...[
                            const Icon(Icons.timer_outlined, size: 18, color: AppColors.textSecondary),
                            const SizedBox(width: 6),
                            Text(
                              'Resend code in 0:${_secondsRemaining.toString().padLeft(2, '0')}',
                              style: AppTypography.bodySmall,
                            ),
                          ] else ...[
                            TextButton(
                              onPressed: () {
                                _startResendTimer();
                                ref.read(authControllerProvider.notifier).sendOtp(widget.phoneNumber);
                              },
                              child: Text(
                                'Didn\'t receive code? Resend SMS',
                                style: AppTypography.labelMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      if (authState.status == AuthStatus.error && authState.errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          authState.errorMessage!,
                          style: AppTypography.bodySmall.copyWith(color: AppColors.error),
                        ),
                      ],
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
