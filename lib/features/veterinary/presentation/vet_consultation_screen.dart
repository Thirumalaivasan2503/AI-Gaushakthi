import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/cards/login_card.dart';
import '../../../core/widgets/feedback/loading_overlay.dart';
import '../../../core/widgets/input/custom_dropdown.dart';
import '../../../core/widgets/input/custom_text_field.dart';

import '../domain/models/consultation_model.dart';
import 'controllers/vet_controller.dart';

/// Tele-Consultation Hub (Video, Audio, Chat Placeholders)
class VetConsultationScreen extends ConsumerStatefulWidget {
  const VetConsultationScreen({super.key});

  @override
  ConsumerState<VetConsultationScreen> createState() => _VetConsultationScreenState();
}

class _VetConsultationScreenState extends ConsumerState<VetConsultationScreen> {
  final _farmerNameController = TextEditingController(text: 'Ramesh Kumar');
  final _animalTagController = TextEditingController(text: 'KANG-01');
  final _slotController = TextEditingController(text: 'Tomorrow 10:00 AM');
  final _prescriptionController = TextEditingController(text: 'Oxytetracycline 10ml, B-Complex 5ml');

  ConsultationType _selectedType = ConsultationType.video;
  bool _activeCall = false;

  @override
  void dispose() {
    _farmerNameController.dispose();
    _animalTagController.dispose();
    _slotController.dispose();
    _prescriptionController.dispose();
    super.dispose();
  }

  void _scheduleConsultation() async {
    final consultation = ConsultationModel(
      id: 'apt_${DateTime.now().millisecondsSinceEpoch}',
      farmerName: _farmerNameController.text.trim(),
      farmerMobile: '+91 98765 43210',
      animalTag: _animalTagController.text.trim(),
      breed: 'Kangayam Cattle',
      type: _selectedType,
      appointmentSlot: _slotController.text.trim(),
    );

    await ref.read(vetRepositoryProvider).addConsultation(consultation);
    await ref.read(vetControllerProvider.notifier).loadVetData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Consultation appointment scheduled!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vetState = ref.watch(vetControllerProvider);
    final consults = vetState.consultations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tele-Consultation Hub'),
      ),
      body: LoadingOverlay(
        isLoading: vetState.isLoading,
        message: 'Connecting video stream...',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Veterinary Tele-Consultations', style: AppTypography.displayMedium.copyWith(color: AppColors.primary)),
                const SizedBox(height: 8),
                Text('Connect live with farmers via HD Video, Voice Call, or Direct Chat.', style: AppTypography.bodyMedium),
                const SizedBox(height: 24),

                // Active Call Video Placeholder Window
                if (_activeCall) ...[
                  Container(
                    height: 240,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                    ),
                    child: Stack(
                      children: [
                        const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.videocam, size: 64, color: AppColors.secondary),
                              SizedBox(height: 8),
                              Text('Live Video Stream Active', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              Text('Connected to Ramesh Kumar (KANG-01)', style: TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.mic, color: Colors.white),
                                onPressed: () {},
                              ),
                              const SizedBox(width: 16),
                              FloatingActionButton.small(
                                backgroundColor: AppColors.error,
                                onPressed: () => setState(() => _activeCall = false),
                                child: const Icon(Icons.call_end, color: Colors.white),
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                icon: const Icon(Icons.chat, color: Colors.white),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Schedule New Call Box
                LoginCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Schedule New Consultation', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      CustomTextField(label: 'Farmer Name', controller: _farmerNameController),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(label: 'Animal Ear Tag', controller: _animalTagController),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomDropdown<ConsultationType>(
                              label: 'Call Type',
                              value: _selectedType,
                              items: const [
                                DropdownMenuItem(value: ConsultationType.video, child: Text('HD Video Call')),
                                DropdownMenuItem(value: ConsultationType.audio, child: Text('Voice Call')),
                                DropdownMenuItem(value: ConsultationType.chat, child: Text('Chat Consultation')),
                              ],
                              onChanged: (val) => setState(() => _selectedType = val!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(label: 'Preferred Time Slot', controller: _slotController),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        text: 'Schedule Appointment',
                        onPressed: _scheduleConsultation,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),
                // Scheduled Appointments List
                Text('Scheduled Consultation Appointments', style: AppTypography.titleLarge),
                const SizedBox(height: 12),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: consults.length,
                  itemBuilder: (context, index) {
                    final c = consults[index];
                    return LoginCard(
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Icon(
                              c.type == ConsultationType.video ? Icons.video_call : Icons.phone,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${c.farmerName} (${c.animalTag})', style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold)),
                                Text('${c.breed} • ${c.appointmentSlot}', style: AppTypography.bodySmall),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                            onPressed: () {
                              setState(() => _activeCall = true);
                            },
                            child: const Text('Start Now', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
                          ),
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
