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

import '../domain/models/feed_environmental_model.dart';
import 'controllers/farmer_controller.dart';

/// Feed Management & Agro-Environmental Data Collector Screen (ML Model Prep)
class FeedEnvironmentalScreen extends ConsumerStatefulWidget {
  const FeedEnvironmentalScreen({super.key});

  @override
  ConsumerState<FeedEnvironmentalScreen> createState() => _FeedEnvironmentalScreenState();
}

class _FeedEnvironmentalScreenState extends ConsumerState<FeedEnvironmentalScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _feedTypeController;
  late TextEditingController _dailyQtyController;
  late TextEditingController _dailyCostController;
  late TextEditingController _monthlyCostController;
  late TextEditingController _waterAvailController;
  late TextEditingController _seasonalFeedController;

  late TextEditingController _tempController;
  late TextEditingController _rainfallController;
  late TextEditingController _humidityController;
  late TextEditingController _grazingAreaController;

  String _climateZone = 'Semi-Arid Tropical';
  String _waterSource = 'Borewell & River Canal';
  String _soilType = 'Red Loamy Soil';
  String _currentSeason = 'Monsoon / Kharif';
  bool _usesMinerals = true;

  @override
  void initState() {
    super.initState();
    final data = ref.read(farmerControllerProvider).feedEnv ?? const FeedEnvironmentalModel(id: '1', farmerId: '1');

    _feedTypeController = TextEditingController(text: data.feedType);
    _dailyQtyController = TextEditingController(text: data.dailyQuantityKg.toString());
    _dailyCostController = TextEditingController(text: data.dailyCostInr.toStringAsFixed(0));
    _monthlyCostController = TextEditingController(text: data.monthlyCostInr.toStringAsFixed(0));
    _waterAvailController = TextEditingController(text: data.waterAvailability);
    _seasonalFeedController = TextEditingController(text: data.seasonalFeedChanges);

    _tempController = TextEditingController(text: data.averageTemperatureC.toString());
    _rainfallController = TextEditingController(text: data.annualRainfallMm.toString());
    _humidityController = TextEditingController(text: data.humidityPercentage.toString());
    _grazingAreaController = TextEditingController(text: data.grazingAreaAcres.toString());

    _climateZone = data.climateZone;
    _waterSource = data.waterSource;
    _soilType = data.soilType;
    _currentSeason = data.currentSeason;
    _usesMinerals = data.usesMineralSupplements;
  }

  @override
  void dispose() {
    _feedTypeController.dispose();
    _dailyQtyController.dispose();
    _dailyCostController.dispose();
    _monthlyCostController.dispose();
    _waterAvailController.dispose();
    _seasonalFeedController.dispose();
    _tempController.dispose();
    _rainfallController.dispose();
    _humidityController.dispose();
    _grazingAreaController.dispose();
    super.dispose();
  }

  void _saveData() async {
    if (_formKey.currentState?.validate() ?? false) {
      final model = FeedEnvironmentalModel(
        id: 'feed_env_1',
        farmerId: 'frm_1',
        feedType: _feedTypeController.text.trim(),
        dailyQuantityKg: double.tryParse(_dailyQtyController.text) ?? 25.0,
        dailyCostInr: double.tryParse(_dailyCostController.text) ?? 180.0,
        monthlyCostInr: double.tryParse(_monthlyCostController.text) ?? 5400.0,
        waterAvailability: _waterAvailController.text.trim(),
        usesMineralSupplements: _usesMinerals,
        seasonalFeedChanges: _seasonalFeedController.text.trim(),
        averageTemperatureC: double.tryParse(_tempController.text) ?? 32.5,
        annualRainfallMm: double.tryParse(_rainfallController.text) ?? 750.0,
        humidityPercentage: double.tryParse(_humidityController.text) ?? 68.0,
        climateZone: _climateZone,
        waterSource: _waterSource,
        soilType: _soilType,
        grazingAreaAcres: double.tryParse(_grazingAreaController.text) ?? 3.0,
        currentSeason: _currentSeason,
      );

      await ref.read(farmerControllerProvider.notifier).saveFeedEnvData(model);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feed & Environmental data saved for AI Recommendation Engine!')),
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
        title: const Text('Feed & Climate Inputs'),
      ),
      body: LoadingOverlay(
        isLoading: farmerState.isLoading,
        message: 'Saving ML recommendation parameters...',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLg,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Feed & Agro-Climate Collector', style: AppTypography.displayMedium.copyWith(color: AppColors.primary)),
                  const SizedBox(height: 8),
                  Text('Collects environmental vectors used by the ML engine to recommend optimal indigenous breeds.', style: AppTypography.bodyMedium),
                  const SizedBox(height: 24),

                  // Section 1: Feed Management
                  LoginCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.grass, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text('1. Fodder & Feed Ration', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'Primary Feed Type',
                          hint: 'Co-4 Napier Grass, Sorghum, Cottonseed Cake',
                          controller: _feedTypeController,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'Daily Quantity (kg)',
                                controller: _dailyQtyController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextField(
                                label: 'Monthly Feed Cost (₹)',
                                controller: _monthlyCostController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          label: 'Water Availability Description',
                          controller: _waterAvailController,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Checkbox(
                              value: _usesMinerals,
                              activeColor: AppColors.secondary,
                              onChanged: (val) => setState(() => _usesMinerals = val ?? true),
                            ),
                            Text('Uses Mineral Mixture / Salt Licks', style: AppTypography.bodyMedium),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Section 2: Agro-Climate (ML Inputs)
                  LoginCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.cloud_outlined, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text('2. Agro-Climate & Soil Factors', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomDropdown<String>(
                          label: 'Agro-Climate Zone',
                          value: _climateZone,
                          items: const [
                            DropdownMenuItem(value: 'Semi-Arid Tropical', child: Text('Semi-Arid Tropical')),
                            DropdownMenuItem(value: 'Arid Desert Zone', child: Text('Arid Desert Zone')),
                            DropdownMenuItem(value: 'Humid Coastal / Subtropical', child: Text('Humid Coastal / Subtropical')),
                            DropdownMenuItem(value: 'Hilly Mountainous Zone', child: Text('Hilly Mountainous Zone')),
                          ],
                          onChanged: (val) => setState(() => _climateZone = val!),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'Avg Temp (°C)',
                                controller: _tempController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextField(
                                label: 'Rainfall (mm)',
                                controller: _rainfallController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: CustomDropdown<String>(
                                label: 'Water Source',
                                value: _waterSource,
                                items: const [
                                  DropdownMenuItem(value: 'Borewell & River Canal', child: Text('Borewell & Canal')),
                                  DropdownMenuItem(value: 'Rainfed Pond', child: Text('Rainfed Pond')),
                                  DropdownMenuItem(value: 'Open Well', child: Text('Open Well')),
                                ],
                                onChanged: (val) => setState(() => _waterSource = val!),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextField(
                                label: 'Grazing Area (Acres)',
                                controller: _grazingAreaController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),
                  PrimaryButton(
                    text: 'Save Feed & Climate Data',
                    onPressed: _saveData,
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
