import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/cards/login_card.dart';
import '../../../core/widgets/feedback/loading_overlay.dart';
import '../../../core/widgets/feedback/vaccination_timeline.dart';
import '../../../core/widgets/input/custom_text_field.dart';
import '../domain/models/medical_vaccination_model.dart';
import 'controllers/farmer_controller.dart';

/// Medical History Log & Vaccination Calendar Screen
class MedicalVaccinationScreen extends ConsumerStatefulWidget {
  const MedicalVaccinationScreen({super.key});

  @override
  ConsumerState<MedicalVaccinationScreen> createState() => _MedicalVaccinationScreenState();
}

class _MedicalVaccinationScreenState extends ConsumerState<MedicalVaccinationScreen> {
  final _diseaseController = TextEditingController();
  final _doctorController = TextEditingController(text: 'Dr. Ananya Sharma');
  final _medicinesController = TextEditingController();

  final _vaccineNameController = TextEditingController(text: 'FMD Quadrivalent Booster');
  final _nextDueDateController = TextEditingController(text: '2024-09-15');

  bool _isAddingMedical = false;
  bool _isAddingVaccine = false;

  @override
  void dispose() {
    _diseaseController.dispose();
    _doctorController.dispose();
    _medicinesController.dispose();
    _vaccineNameController.dispose();
    _nextDueDateController.dispose();
    super.dispose();
  }

  void _saveMedicalRecord() async {
    if (_diseaseController.text.isNotEmpty) {
      final record = MedicalRecordModel(
        id: 'med_${DateTime.now().millisecondsSinceEpoch}',
        livestockId: 'anim_1',
        diseaseName: _diseaseController.text.trim(),
        diagnosisDate: DateTime.now().toString().split(' ')[0],
        veterinaryDoctorName: _doctorController.text.trim(),
        medicinesPrescribed: _medicinesController.text.trim(),
      );

      await ref.read(farmerControllerProvider.notifier).addMedicalRecord(record);
      setState(() => _isAddingMedical = false);
      _diseaseController.clear();
      _medicinesController.clear();
    }
  }

  void _saveVaccineRecord() async {
    if (_vaccineNameController.text.isNotEmpty) {
      final record = VaccinationRecordModel(
        id: 'vac_${DateTime.now().millisecondsSinceEpoch}',
        livestockId: 'anim_1',
        vaccineName: _vaccineNameController.text.trim(),
        vaccinationDate: DateTime.now().toString().split(' ')[0],
        nextDueDate: _nextDueDateController.text.trim(),
        vaccinatedBy: _doctorController.text.trim(),
        isCompleted: true,
      );

      await ref.read(farmerControllerProvider.notifier).addVaccinationRecord(record);
      setState(() => _isAddingVaccine = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final farmerState = ref.watch(farmerControllerProvider);
    final medicals = farmerState.medicalRecords;
    final vaccinations = farmerState.vaccinationRecords;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical & Vaccination Hub'),
      ),
      body: LoadingOverlay(
        isLoading: farmerState.isLoading,
        message: 'Updating health records...',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Health & Vaccination Registry', style: AppTypography.displayMedium.copyWith(color: AppColors.primary)),
                const SizedBox(height: 8),
                Text('Track vaccinations, treatments, hospital visits, and booster reminders.', style: AppTypography.bodyMedium),
                const SizedBox(height: 24),

                // Vaccination Calendar Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Vaccination Schedule & Due Dates', style: AppTypography.titleLarge),
                    TextButton.icon(
                      onPressed: () => setState(() => _isAddingVaccine = !_isAddingVaccine),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Log Vaccine'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (_isAddingVaccine) ...[
                  LoginCard(
                    child: Column(
                      children: [
                        CustomTextField(label: 'Vaccine Name', controller: _vaccineNameController),
                        const SizedBox(height: 12),
                        CustomTextField(label: 'Next Due Date', controller: _nextDueDateController),
                        const SizedBox(height: 16),
                        PrimaryButton(text: 'Save Vaccine Entry', onPressed: _saveVaccineRecord),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                VaccinationTimelineWidget(records: vaccinations),

                const SizedBox(height: 28),
                // Medical Treatment Records
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Medical & Disease Logs', style: AppTypography.titleLarge),
                    TextButton.icon(
                      onPressed: () => setState(() => _isAddingMedical = !_isAddingMedical),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Log Treatment'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (_isAddingMedical) ...[
                  LoginCard(
                    child: Column(
                      children: [
                        CustomTextField(label: 'Disease / Diagnosis', hint: 'Foot Rot', controller: _diseaseController),
                        const SizedBox(height: 12),
                        CustomTextField(label: 'Veterinary Doctor', controller: _doctorController),
                        const SizedBox(height: 12),
                        CustomTextField(label: 'Medicines Prescribed', hint: 'Oxytetracycline', controller: _medicinesController),
                        const SizedBox(height: 16),
                        PrimaryButton(text: 'Save Medical Log', onPressed: _saveMedicalRecord),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: medicals.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final m = medicals[index];
                    return LoginCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(m.diseaseName, style: AppTypography.titleMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                              Text(m.diagnosisDate, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text('Doctor: ${m.veterinaryDoctorName}', style: AppTypography.bodySmall),
                          Text('Medicines: ${m.medicinesPrescribed}', style: AppTypography.bodySmall),
                          Text('Status: ${m.recoveryStatus}', style: AppTypography.labelSmall.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
