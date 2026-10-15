import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/buttons/secondary_button.dart';
import '../../../core/widgets/cards/login_card.dart';
import '../../../core/widgets/feedback/loading_overlay.dart';
import '../../../core/widgets/input/country_code_picker.dart';
import '../../../core/widgets/input/custom_text_field.dart';
import '../../../core/widgets/input/language_picker.dart';
import '../../../core/widgets/input/password_field.dart';
import '../domain/models/auth_state.dart';
import '../domain/user_role.dart';
import '../domain/utils/validators.dart';
import 'controllers/auth_controller.dart';

/// User Login Screen UI with Forest Green + Gold Aesthetics
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController(text: '9876543210');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController(text: 'Password123');
  bool _useEmailLogin = false;
  String _selectedCountryCode = '+91';
  String _currentLanguage = 'en';

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final phone = '$_selectedCountryCode${_phoneController.text.trim()}';
      await ref.read(authControllerProvider.notifier).loginWithMobile(
            phone,
            _passwordController.text,
          );

      final authState = ref.read(authControllerProvider);
      if (authState.status == AuthStatus.authenticated && authState.user != null) {
        _navigateBasedOnRole(authState.user!.role);
      }
    }
  }

  void _handleOtpLogin() async {
    final phone = '$_selectedCountryCode${_phoneController.text.trim()}';
    await ref.read(authControllerProvider.notifier).sendOtp(phone);
    if (mounted) {
      context.push('/auth/otp', extra: phone);
    }
  }

  void _navigateBasedOnRole(UserRole role) {
    if (!mounted) return;
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
      body: LoadingOverlay(
        isLoading: authState.status == AuthStatus.loading,
        message: 'Authenticating credentials...',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLg,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // Header Row with Logo and Language Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: AppColors.goldGradient,
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.pets, color: AppColors.primaryDark, size: 28),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('PasuMitra AI', style: AppTypography.headlineMedium.copyWith(color: AppColors.primary)),
                              Text('Livestock AgriTech Portal', style: AppTypography.bodySmall),
                            ],
                          ),
                        ],
                      ),
                      LanguagePickerWidget(
                        currentLanguageCode: _currentLanguage,
                        onLanguageChanged: (lang) {
                          setState(() {
                            _currentLanguage = lang;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  LoginCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome Back', style: AppTypography.displaySmall.copyWith(color: AppColors.primary)),
                        const SizedBox(height: 6),
                        Text(
                          'Sign in to access indigenous breed recommendation AI models and farm management tools.',
                          style: AppTypography.bodyMedium,
                        ),
                        const SizedBox(height: 24),

                        // Login Type Toggle
                        Row(
                          children: [
                            Expanded(
                              child: ChoiceChip(
                                label: const Text('Mobile Login'),
                                selected: !_useEmailLogin,
                                selectedColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  color: !_useEmailLogin ? Colors.white : AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                                onSelected: (selected) {
                                  setState(() {
                                    _useEmailLogin = false;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ChoiceChip(
                                label: const Text('Email Login'),
                                selected: _useEmailLogin,
                                selectedColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  color: _useEmailLogin ? Colors.white : AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                                onSelected: (selected) {
                                  setState(() {
                                    _useEmailLogin = true;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Input fields
                        if (!_useEmailLogin) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CountryCodePickerWidget(
                                selectedCode: _selectedCountryCode,
                                onChanged: (val) {
                                  setState(() {
                                    _selectedCountryCode = val;
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: CustomTextField(
                                  label: 'Mobile Number',
                                  hint: '9876543210',
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  prefixIcon: Icons.phone_android,
                                  validator: Validators.validateMobile,
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          CustomTextField(
                            label: 'Email Address',
                            hint: 'farmer@pasumitra.org',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                            validator: Validators.validateEmail,
                          ),
                        ],
                        const SizedBox(height: 16),

                        PasswordField(
                          label: 'Password',
                          controller: _passwordController,
                          validator: Validators.validatePassword,
                        ),
                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: authState.rememberMe,
                                  activeColor: AppColors.secondary,
                                  onChanged: (val) {
                                    ref.read(authControllerProvider.notifier).setRememberMe(val ?? true);
                                  },
                                ),
                                Text('Remember me', style: AppTypography.bodySmall),
                              ],
                            ),
                            TextButton(
                              onPressed: () => context.push('/auth/forgot-password'),
                              child: Text(
                                'Forgot Password?',
                                style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),

                        if (authState.status == AuthStatus.error && authState.errorMessage != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.error),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    authState.errorMessage!,
                                    style: AppTypography.bodySmall.copyWith(color: AppColors.error),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),

                        PrimaryButton(
                          text: 'Log In',
                          onPressed: _handleLogin,
                        ),
                        const SizedBox(height: 12),

                        SecondaryButton(
                          text: 'Continue with 6-Digit OTP',
                          onPressed: _handleOtpLogin,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account?', style: AppTypography.bodyMedium),
                        TextButton(
                          onPressed: () => context.push('/auth/register'),
                          child: Text(
                            'Register Now',
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.secondaryDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
