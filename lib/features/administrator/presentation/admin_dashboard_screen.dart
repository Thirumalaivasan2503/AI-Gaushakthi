import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../authentication/presentation/controllers/auth_controller.dart';

/// Dedicated Dashboard Screen for System & Livestock Administrators
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('System Administration'),
        backgroundColor: AppColors.primaryDark,
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: AppSpacing.borderRadiusLg,
                  border: Border.all(color: AppColors.secondary, width: 1.5),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.secondary,
                      child: Icon(Icons.admin_panel_settings, color: AppColors.primaryDark, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.fullName ?? 'Administrator',
                            style: AppTypography.titleLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.adminProfile?.department ?? 'State Animal Husbandry Board',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.secondaryLight),
                          ),
                          Text(
                            'Level: ${user?.adminProfile?.adminLevel ?? "System SuperAdmin"}',
                            style: AppTypography.labelSmall.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text('System Control & Monitoring', style: AppTypography.headlineSmall),
              const SizedBox(height: 12),

              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildAdminTile(
                    context,
                    title: 'User Access Management',
                    subtitle: 'Manage Farmers, Vets, and Admin roles & permissions',
                    icon: Icons.people_outline,
                    onTap: () {},
                  ),
                  _buildAdminTile(
                    context,
                    title: 'AI Model Training & Telemetry Logs',
                    subtitle: 'Monitor breed recommendation accuracy & model versions',
                    icon: Icons.smart_toy_outlined,
                    onTap: () {},
                  ),
                  _buildAdminTile(
                    context,
                    title: 'System Audit Logs',
                    subtitle: 'View security events, authentication attempts, and API traffic',
                    icon: Icons.security_outlined,
                    onTap: () {},
                  ),
                  _buildAdminTile(
                    context,
                    title: 'Database Synchronization',
                    subtitle: 'Trigger PostgreSQL & SQLite offline payload syncs',
                    icon: Icons.sync,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary, size: 28),
        title: Text(title, style: AppTypography.titleMedium),
        subtitle: Text(subtitle, style: AppTypography.bodySmall),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
