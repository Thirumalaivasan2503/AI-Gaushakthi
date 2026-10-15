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
import '../domain/models/livestock_model.dart';
import 'controllers/farmer_controller.dart';

/// Step-by-Step Animal Registration & Edit Form
class AddEditLivestockScreen extends ConsumerStatefulWidget {
  final String? animalIdToEdit;

  const AddEditLivestockScreen({
    super.key,
    this.animalIdToEdit,
  });

  @override
  ConsumerState<AddEditLivestockScreen> createState() => _AddEditLivestockScreenState();
}

class _AddEditLivestockScreenState extends ConsumerState<AddEditLivestockScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 1;

  final _animalIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController(text: 'Kangayam Cattle');
  final _dobController = TextEditingController(text: '2022-05-10');

  final _ageController = TextEditingController(text: '2.0');
  final _weightController = TextEditingController(text: '350');
  final _heightController = TextEditingController(text: '130');
  final _colorController = TextEditingController(text: 'Greyish White');
  final _earTagController = TextEditingController(text: 'TAG-TN-9901');

  final _purchaseDateController = TextEditingController(text: '2022-08-15');
  final _purchaseCostController = TextEditingController(text: '50000');

  LivestockSpecies _species = LivestockSpecies.cattle;
  String _gender = 'Female';
  LivestockHealthStatus _healthStatus = LivestockHealthStatus.healthy;

  @override
  void initState() {
    super.initState();
    if (widget.animalIdToEdit != null) {
      _loadExistingAnimal();
    } else {
      _animalIdController.text = 'KANG-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
      _nameController.text = 'Lakshmi';
    }
  }

  void _loadExistingAnimal() async {
    final existing = await ref.read(farmerRepositoryProvider).getLivestockById(widget.animalIdToEdit!);
    if (existing != null) {
      _animalIdController.text = existing.animalId;
      _nameController.text = existing.name;
      _breedController.text = existing.breed;
      _dobController.text = existing.dob;
      _ageController.text = existing.ageYears.toString();
      _weightController.text = existing.weightKg.toString();
      _heightController.text = existing.heightCm.toString();
      _colorController.text = existing.color;
      _earTagController.text = existing.earTagNumber;
      _purchaseDateController.text = existing.purchaseDate;
      _purchaseCostController.text = existing.purchaseCost.toStringAsFixed(0);
      _species = existing.species;
      _gender = existing.gender;
      _healthStatus = existing.healthStatus;
    }
  }

  @override
  void dispose() {
    _animalIdController.dispose();
    _nameController.dispose();
    _breedController.dispose();
    _dobController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _colorController.dispose();
    _earTagController.dispose();
    _purchaseDateController.dispose();
    _purchaseCostController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final animal = LivestockModel(
        id: widget.animalIdToEdit ?? 'anim_${DateTime.now().millisecondsSinceEpoch}',
        animalId: _animalIdController.text.trim(),
        name: _nameController.text.trim(),
        breed: _breedController.text.trim(),
        species: _species,
        gender: _gender,
        dob: _dobController.text.trim(),
        ageYears: double.tryParse(_ageController.text) ?? 2.0,
        weightKg: double.tryParse(_weightController.text) ?? 350.0,
        heightCm: double.tryParse(_heightController.text) ?? 130.0,
        color: _colorController.text.trim(),
        earTagNumber: _earTagController.text.trim(),
        purchaseDate: _purchaseDateController.text.trim(),
        purchaseCost: double.tryParse(_purchaseCostController.text) ?? 45000.0,
        healthStatus: _healthStatus,
      );

      if (widget.animalIdToEdit != null) {
        await ref.read(farmerControllerProvider.notifier).updateAnimal(animal);
      } else {
        await ref.read(farmerControllerProvider.notifier).addAnimal(animal);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Livestock registered successfully!')),
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
        title: Text(widget.animalIdToEdit != null ? 'Edit Animal' : 'Register New Animal'),
      ),
      body: LoadingOverlay(
        isLoading: farmerState.isLoading,
        message: 'Saving animal registration...',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLg,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step Indicator Header
                  Row(
                    children: [
                      _buildStepCircle(1, 'Identity'),
                      _buildStepDivider(),
                      _buildStepCircle(2, 'Metrics'),
                      _buildStepDivider(),
                      _buildStepCircle(3, 'Health & Cost'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  if (_currentStep == 1) ...[
                    LoginCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Step 1: Animal Identity', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Animal Tag / ID',
                            hint: 'KANG-01',
                            controller: _animalIdController,
                            validator: (val) => Validators.validateRequired(val, 'Animal ID'),
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            label: 'Animal Name',
                            hint: 'Lakshmi',
                            controller: _nameController,
                            validator: (val) => Validators.validateRequired(val, 'Animal Name'),
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            label: 'Breed Name',
                            hint: 'Kangayam Cattle / Sahiwal / Bargur',
                            controller: _breedController,
                            validator: (val) => Validators.validateRequired(val, 'Breed Name'),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: CustomDropdown<LivestockSpecies>(
                                  label: 'Species',
                                  value: _species,
                                  items: LivestockSpecies.values.map((s) {
                                    return DropdownMenuItem(value: s, child: Text(s.displayName));
                                  }).toList(),
                                  onChanged: (val) => setState(() => _species = val!),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomDropdown<String>(
                                  label: 'Gender',
                                  value: _gender,
                                  items: const [
                                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                                  ],
                                  onChanged: (val) => setState(() => _gender = val!),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            label: 'Date of Birth',
                            hint: 'YYYY-MM-DD',
                            controller: _dobController,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      text: 'Next: Physical Metrics',
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          setState(() => _currentStep = 2);
                        }
                      },
                    ),
                  ] else if (_currentStep == 2) ...[
                    LoginCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Step 2: Physical Attributes', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: 'Age (Years)',
                                  hint: '2.5',
                                  controller: _ageController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  label: 'Weight (kg)',
                                  hint: '380',
                                  controller: _weightController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: 'Height (cm)',
                                  hint: '132',
                                  controller: _heightController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  label: 'Color / Markings',
                                  hint: 'Greyish White',
                                  controller: _colorController,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            label: 'Ear Tag Barcode Number',
                            hint: 'TAG-TN-9801',
                            controller: _earTagController,
                            validator: (val) => Validators.validateRequired(val, 'Ear Tag Number'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => _currentStep = 1),
                            child: const Text('Back'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: PrimaryButton(
                            text: 'Next: Health & Purchase',
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                setState(() => _currentStep = 3);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    LoginCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Step 3: Purchase & Health Status', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          CustomDropdown<LivestockHealthStatus>(
                            label: 'Current Health Status',
                            value: _healthStatus,
                            items: LivestockHealthStatus.values.map((h) {
                              return DropdownMenuItem(value: h, child: Text(h.label));
                            }).toList(),
                            onChanged: (val) => setState(() => _healthStatus = val!),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: 'Purchase Date',
                                  hint: 'YYYY-MM-DD',
                                  controller: _purchaseDateController,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  label: 'Purchase Cost (₹)',
                                  hint: '50000',
                                  controller: _purchaseCostController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => _currentStep = 2),
                            child: const Text('Back'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: PrimaryButton(
                            text: 'Save Livestock',
                            onPressed: _submitForm,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepCircle(int stepNum, String title) {
    final isActive = _currentStep >= stepNum;
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: isActive ? AppColors.primary : AppColors.border,
          child: Text(
            stepNum.toString(),
            style: AppTypography.labelSmall.copyWith(
              color: isActive ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: AppTypography.labelSmall),
      ],
    );
  }

  Widget _buildStepDivider() {
    return Expanded(
      child: Container(
        height: 2,
        color: AppColors.border,
        margin: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }
}
