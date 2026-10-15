import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/feedback/loading_overlay.dart';
import '../../authentication/presentation/controllers/auth_controller.dart';
import '../domain/models/consultation_model.dart';
import 'controllers/vet_controller.dart';

/// Dedicated Dashboard Screen for Veterinary Experts & Specialists
class VeterinaryDashboardScreen extends ConsumerWidget {
  const VeterinaryDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final vetState = ref.watch(vetControllerProvider);

    final consults = vetState.consultations;
    final pendingReports = vetState.pendingReports;
    final diseases = vetState.diseases;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Veterinary Portal'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).logout();
              if (context.mounted) {
                context.go('/auth/login');
              }
            },
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: vetState.isLoading,
        message: 'Loading veterinary portal data...',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: AppSpacing.borderRadiusLg,
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.secondary,
                        child: Icon(Icons.medical_services, color: AppColors.primaryDark, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.fullName ?? 'Dr. Ananya Sharma',
                              style: AppTypography.titleLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.veterinaryProfile?.specialization ?? 'Breeding & Telemetry Expert',
                              style: AppTypography.bodySmall.copyWith(color: AppColors.secondaryLight),
                            ),
                            Text(
                              'Reg No: ${user?.veterinaryProfile?.registrationNumber ?? "VET-TN-2024-998"}',
                              style: AppTypography.labelSmall.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Quick Analytics Grid
                Text('Practice Overview & Telemetry', style: AppTypography.headlineSmall),
                const SizedBox(height: 12),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    _buildStatCard(
                      context,
                      title: 'Today Consults',
                      value: consults.length.toString(),
                      subtitle: 'Scheduled',
                      icon: Icons.video_call_outlined,
                      color: AppColors.primary,
                    ),
                    _buildStatCard(
                      context,
                      title: 'Pending Reports',
                      value: pendingReports.length.toString(),
                      subtitle: 'Needs Review',
                      icon: Icons.assignment_outlined,
                      color: AppColors.warning,
                    ),
                    _buildStatCard(
                      context,
                      title: 'Disease Alerts',
                      value: diseases.where((d) => d.isEmergency).length.toString(),
                      subtitle: 'Emergency Active',
                      icon: Icons.error_outline,
                      color: AppColors.error,
                    ),
                    _buildStatCard(
                      context,
                      title: 'Breeds Database',
                      value: '7',
                      subtitle: 'Encyclopedia',
                      icon: Icons.menu_book,
                      color: AppColors.secondaryDark,
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                // Quick Action Buttons
                Text('Veterinary Workspace', style: AppTypography.titleLarge),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        context,
                        title: 'Disease Database',
                        icon: Icons.healing,
                        color: AppColors.primary,
                        onTap: () => context.push('/vet/diseases'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                        context,
                        title: 'Report Review',
                        icon: Icons.rate_review_outlined,
                        color: AppColors.warning,
                        onTap: () => context.push('/vet/reports'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                        context,
                        title: 'Tele-Consults',
                        icon: Icons.headset_mic_outlined,
                        color: AppColors.secondaryDark,
                        onTap: () => context.push('/vet/consultations'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),
                // Today's Appointments
                Text('Today\'s Consultation Queue', style: AppTypography.titleLarge),
                const SizedBox(height: 12),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: consults.length,
                  itemBuilder: (context, index) {
                    final c = consults[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: Icon(
                            c.type == ConsultationType.video
                                ? Icons.video_call
                                : (c.type == ConsultationType.audio ? Icons.phone : Icons.chat),
                            color: AppColors.primary,
                          ),
                        ),
                        title: Text('${c.farmerName} (${c.animalTag})', style: AppTypography.titleMedium),
                        subtitle: Text('${c.breed} • ${c.appointmentSlot}', style: AppTypography.bodySmall),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          onPressed: () => context.push('/vet/consultations'),
                          child: const Text('Start Call', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
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

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: AppTypography.headlineMedium.copyWith(color: color, fontWeight: FontWeight.bold)),
                Text(title, style: AppTypography.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(subtitle, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(title, style: AppTypography.labelSmall.copyWith(color: color, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
