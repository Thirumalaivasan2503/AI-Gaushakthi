import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/cards/login_card.dart';
import '../../../core/widgets/feedback/loading_overlay.dart';
import '../../../core/widgets/input/country_code_picker.dart';
import '../../../core/widgets/input/custom_text_field.dart';
import '../../../core/widgets/input/password_field.dart';
import '../../../core/widgets/input/role_selector.dart';
import '../domain/models/auth_state.dart';
import '../domain/user_role.dart';
import '../domain/utils/validators.dart';
import 'controllers/auth_controller.dart';

/// User Registration Screen UI
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Ramesh Kumar');
  final _phoneController = TextEditingController(text: '9876543210');
  final _emailController = TextEditingController(text: 'ramesh@pasumitra.org');
  final _passwordController = TextEditingController(text: 'Password123');
  final _confirmPasswordController = TextEditingController(text: 'Password123');
  final _stateController = TextEditingController(text: 'Tamil Nadu');
  final _districtController = TextEditingController(text: 'Coimbatore');
  final _villageController = TextEditingController(text: 'Pollachi');

  UserRole _selectedRole = UserRole.ruralFarmer;
  String _selectedCountryCode = '+91';
  bool _acceptTerms = false;
  String? _termsError;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    _villageController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    setState(() {
      _termsError = _acceptTerms ? null : 'You must accept Terms & Privacy Policy';
    });

    if ((_formKey.currentState?.validate() ?? false) && _acceptTerms) {
      final phone = '$_selectedCountryCode${_phoneController.text.trim()}';
      await ref.read(authControllerProvider.notifier).registerUser(
            fullName: _nameController.text.trim(),
            mobile: phone,
            email: _emailController.text.trim(),
            password: _passwordController.text,
            role: _selectedRole,
            stateName: _stateController.text.trim(),
            district: _districtController.text.trim(),
            village: _villageController.text.trim(),
          );

      final authState = ref.read(authControllerProvider);
      if (authState.status == AuthStatus.authenticated && authState.user != null) {
        if (mounted) {
          _navigateBasedOnRole(authState.user!.role);
        }
      }
    }
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
        title: const Text('Create Account'),
      ),
      body: LoadingOverlay(
        isLoading: authState.status == AuthStatus.loading,
        message: 'Creating account & registering profile...',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLg,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Register Your Farm Persona', style: AppTypography.displayMedium.copyWith(color: AppColors.primary)),
                  const SizedBox(height: 8),
                  Text(
                    'Join thousands of farmers, veterinarians, and agri-specialists using AI for indigenous breed preservation.',
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  LoginCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User Role / Persona', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        RoleSelectorWidget(
                          selectedRole: _selectedRole,
                          onRoleSelected: (role) {
                            setState(() {
                              _selectedRole = role;
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        CustomTextField(
                          label: 'Full Name',
                          hint: 'Ramesh Kumar',
                          controller: _nameController,
                          prefixIcon: Icons.person_outline,
                          validator: (val) => Validators.validateRequired(val, 'Full Name'),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CountryCodePickerWidget(
                              selectedCode: _selectedCountryCode,
                              onChanged: (val) => setState(() => _selectedCountryCode = val),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: CustomTextField(
                                label: 'Mobile Phone Number',
                                hint: '9876543210',
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                prefixIcon: Icons.phone_android,
                                validator: Validators.validateMobile,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          label: 'Email Address',
                          hint: 'ramesh@pasumitra.org',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: Validators.validateEmail,
                        ),
                        const SizedBox(height: 16),

                        PasswordField(
                          label: 'Password',
                          controller: _passwordController,
                          validator: Validators.validatePassword,
                        ),
                        const SizedBox(height: 16),

                        PasswordField(
                          label: 'Confirm Password',
                          controller: _confirmPasswordController,
                          validator: (val) => Validators.validateConfirmPassword(
                            _passwordController.text,
                            val,
                          ),
                        ),
                        const SizedBox(height: 20),

                        Text('Geographic Location (State / District / Village)',
                            style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'State',
                                hint: 'Tamil Nadu',
                                controller: _stateController,
                                validator: (val) => Validators.validateRequired(val, 'State'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextField(
                                label: 'District',
                                hint: 'Coimbatore',
                                controller: _districtController,
                                validator: (val) => Validators.validateRequired(val, 'District'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'Village / Town',
                          hint: 'Pollachi Rural',
                          controller: _villageController,
                          validator: (val) => Validators.validateRequired(val, 'Village'),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _acceptTerms,
                              activeColor: AppColors.secondary,
                              onChanged: (val) {
                                setState(() {
                                  _acceptTerms = val ?? false;
                                  if (_acceptTerms) _termsError = null;
                                });
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Wrap(
                                  children: [
                                    Text('I accept the ', style: AppTypography.bodySmall),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        'Terms of Service',
                                        style: AppTypography.bodySmall.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(' and ', style: AppTypography.bodySmall),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        'Privacy Policy',
                                        style: AppTypography.bodySmall.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_termsError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              _termsError!,
                              style: AppTypography.bodySmall.copyWith(color: AppColors.error),
                            ),
                          ),

                        if (authState.status == AuthStatus.error && authState.errorMessage != null) ...[
                          const SizedBox(height: 16),
                          Text(authState.errorMessage!, style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
                        ],

                        const SizedBox(height: 28),
                        PrimaryButton(
                          text: 'Create Account & Verify OTP',
                          onPressed: _handleRegister,
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
