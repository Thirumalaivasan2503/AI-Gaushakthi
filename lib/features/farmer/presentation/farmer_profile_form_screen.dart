import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/cards/login_card.dart';
import '../../../core/widgets/feedback/loading_overlay.dart';
import '../../../core/widgets/input/custom_dropdown.dart';
import '../../../core/widgets/input/custom_text_field.dart';

import '../../authentication/domain/utils/validators.dart';
import '../domain/models/farmer_profile_model.dart';
import 'controllers/farmer_controller.dart';

/// Farmer Profile & Farm Registry Edit Screen
class FarmerProfileFormScreen extends ConsumerStatefulWidget {
  const FarmerProfileFormScreen({super.key});

  @override
  ConsumerState<FarmerProfileFormScreen> createState() => _FarmerProfileFormScreenState();
}

class _FarmerProfileFormScreenState extends ConsumerState<FarmerProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _genderController;
  late TextEditingController _dobController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _aadhaarController;

  late TextEditingController _stateController;
  late TextEditingController _districtController;
  late TextEditingController _talukController;
  late TextEditingController _villageController;
  late TextEditingController _pinController;
  late TextEditingController _gpsController;

  late TextEditingController _farmNameController;
  late TextEditingController _farmSizeController;
  late TextEditingController _expController;
  late TextEditingController _workersController;

  late TextEditingController _monthlyBudgetController;
  late TextEditingController _feedBudgetController;
  late TextEditingController _medicalBudgetController;

  String _farmingType = 'Traditional Rural';
  String _primaryLivestockType = 'Kangayam Cattle & Native Goats';
  late List<ProductivityGoal> _selectedGoals;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(farmerControllerProvider).profile ??
        const FarmerProfileModel(
          id: 'frm_1',
          userId: 'usr_1',
          fullName: 'Ramesh Kumar',
          mobile: '+91 98765 43210',
          email: 'ramesh@pasumitra.org',
          state: 'Tamil Nadu',
          district: 'Coimbatore',
          village: 'Kottur',
          farmName: 'Sri Amman Indigenous Cattle Farm',
        );

    _nameController = TextEditingController(text: profile.fullName);
    _genderController = TextEditingController(text: profile.gender);
    _dobController = TextEditingController(text: profile.dob);
    _mobileController = TextEditingController(text: profile.mobile);
    _emailController = TextEditingController(text: profile.email);
    _aadhaarController = TextEditingController(text: profile.aadhaarNumber);

    _stateController = TextEditingController(text: profile.state);
    _districtController = TextEditingController(text: profile.district);
    _talukController = TextEditingController(text: profile.taluk);
    _villageController = TextEditingController(text: profile.village);
    _pinController = TextEditingController(text: profile.pinCode);
    _gpsController = TextEditingController(text: profile.gpsLocation);

    _farmNameController = TextEditingController(text: profile.farmName);
    _farmSizeController = TextEditingController(text: profile.farmSizeAcres.toString());
    _expController = TextEditingController(text: profile.farmingExperienceYears.toString());
    _workersController = TextEditingController(text: profile.numberOfWorkers.toString());

    _monthlyBudgetController = TextEditingController(text: profile.monthlyFarmingBudget.toStringAsFixed(0));
    _feedBudgetController = TextEditingController(text: profile.feedBudget.toStringAsFixed(0));
    _medicalBudgetController = TextEditingController(text: profile.medicalBudget.toStringAsFixed(0));

    _farmingType = profile.farmingType;
    _primaryLivestockType = profile.primaryLivestockType;
    _selectedGoals = List.from(profile.productivityGoals);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _genderController.dispose();
    _dobController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _aadhaarController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    _talukController.dispose();
    _villageController.dispose();
    _pinController.dispose();
    _gpsController.dispose();
    _farmNameController.dispose();
    _farmSizeController.dispose();
    _expController.dispose();
    _workersController.dispose();
    _monthlyBudgetController.dispose();
    _feedBudgetController.dispose();
    _medicalBudgetController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      final current = ref.read(farmerControllerProvider).profile;
      final updated = (current ?? const FarmerProfileModel(
        id: 'frm_1',
        userId: 'usr_1',
        fullName: '',
        mobile: '',
        email: '',
        state: '',
        district: '',
        village: '',
        farmName: '',
      )).copyWith(
        fullName: _nameController.text.trim(),
        gender: _genderController.text.trim(),
        dob: _dobController.text.trim(),
        mobile: _mobileController.text.trim(),
        email: _emailController.text.trim(),
        aadhaarNumber: _aadhaarController.text.trim(),
        state: _stateController.text.trim(),
        district: _districtController.text.trim(),
        taluk: _talukController.text.trim(),
        village: _villageController.text.trim(),
        pinCode: _pinController.text.trim(),
        gpsLocation: _gpsController.text.trim(),
        farmName: _farmNameController.text.trim(),
        farmSizeAcres: double.tryParse(_farmSizeController.text) ?? 5.0,
        farmingExperienceYears: int.tryParse(_expController.text) ?? 10,
        farmingType: _farmingType,
        numberOfWorkers: int.tryParse(_workersController.text) ?? 2,
        primaryLivestockType: _primaryLivestockType,
        monthlyFarmingBudget: double.tryParse(_monthlyBudgetController.text) ?? 25000.0,
        feedBudget: double.tryParse(_feedBudgetController.text) ?? 15000.0,
        medicalBudget: double.tryParse(_medicalBudgetController.text) ?? 5000.0,
        productivityGoals: _selectedGoals,
      );

      await ref.read(farmerControllerProvider.notifier).updateProfile(updated);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Farmer profile updated successfully!')),
        );
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final farmerState = ref.watch(farmerControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer & Farm Profile'),
      ),
      body: LoadingOverlay(
        isLoading: farmerState.isLoading,
        message: 'Saving profile updates...',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLg,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Farmer Profile Registry', style: AppTypography.displayMedium.copyWith(color: AppColors.primary)),
                  const SizedBox(height: 8),
                  Text(
                    'Maintain your farm parameters and economic productivity goals to power AI breed models.',
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  // Section 1: Personal Details
                  LoginCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text('1. Personal Information', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'Full Name',
                          controller: _nameController,
                          validator: (val) => Validators.validateRequired(val, 'Full Name'),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'Gender',
                                controller: _genderController,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextField(
                                label: 'Date of Birth',
                                controller: _dobController,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          label: 'Mobile Phone Number',
                          controller: _mobileController,
                          validator: Validators.validateMobile,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          label: 'Email Address',
                          controller: _emailController,
                          validator: Validators.validateEmail,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          label: 'Aadhaar Number (Optional)',
                          hint: 'XXXX XXXX XXXX',
                          controller: _aadhaarController,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Section 2: Location
                  LoginCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.map_outlined, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text('2. Geographic Location', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'State',
                                controller: _stateController,
                                validator: (val) => Validators.validateRequired(val, 'State'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextField(
                                label: 'District',
                                controller: _districtController,
                                validator: (val) => Validators.validateRequired(val, 'District'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'Taluk',
                                controller: _talukController,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextField(
                                label: 'Village / Town',
                                controller: _villageController,
                                validator: (val) => Validators.validateRequired(val, 'Village'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'PIN Code',
                                controller: _pinController,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextField(
                                label: 'GPS Coords',
                                controller: _gpsController,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Section 3: Farm Information
                  LoginCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.agriculture, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text('3. Farm Profile & Capacity', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'Farm Name',
                          controller: _farmNameController,
                          validator: (val) => Validators.validateRequired(val, 'Farm Name'),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'Land Size (Acres)',
                                controller: _farmSizeController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextField(
                                label: 'Experience (Years)',
                                controller: _expController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        CustomDropdown<String>(
                          label: 'Farming Type',
                          value: _farmingType,
                          items: const [
                            DropdownMenuItem(value: 'Traditional Rural', child: Text('Traditional Rural')),
                            DropdownMenuItem(value: 'Peri-Urban Dairy', child: Text('Peri-Urban Dairy')),
                            DropdownMenuItem(value: 'Organic Natural Farm', child: Text('Organic Natural Farm')),
                          ],
                          onChanged: (val) => setState(() => _farmingType = val!),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Section 4: Productivity Goals Multi-select
                  LoginCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.flag_outlined, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text('4. Primary Productivity Goals', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Select all objectives that apply to your farming operations:', style: AppTypography.bodySmall),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ProductivityGoal.values.map((goal) {
                            final isSelected = _selectedGoals.contains(goal);
                            return FilterChip(
                              label: Text(goal.title),
                              selected: isSelected,
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedGoals.add(goal);
                                  } else {
                                    _selectedGoals.remove(goal);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),
                  PrimaryButton(
                    text: 'Save Farmer Profile',
                    onPressed: _saveProfile,
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
