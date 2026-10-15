import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/cards/glass_card.dart';
import '../../../core/widgets/cards/profile_card.dart';

/// User Profile, App Settings & Theme Toggle Screen
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account & Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.paddingMd,
          children: [
            ProfileCard(
              userName: 'Ramesh Kumar',
              role: 'Rural Farmer • Coimbatore District',
              emailOrPhone: '+91 98765 43210',
              onEdit: () {},
            ),
            const SizedBox(height: 24),
            Text('App Configuration', style: AppTypography.titleLarge),
            const SizedBox(height: 12),
            GlassCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.palette_outlined, color: AppColors.primary),
                    title: Text('Theme Mode', style: AppTypography.titleMedium),
                    subtitle: Text('Currently: ${themeMode.name.toUpperCase()}', style: AppTypography.bodySmall),
                    trailing: DropdownButton<ThemeMode>(
                      value: themeMode,
                      onChanged: (mode) {
                        if (mode != null) {
                          ref.read(themeModeProvider.notifier).setThemeMode(mode);
                        }
                      },
                      items: const [
                        DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                        DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                        DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.translate, color: AppColors.primary),
                    title: Text('App Language', style: AppTypography.titleMedium),
                    subtitle: Text('English (தமிழ் / हिंदी available)', style: AppTypography.bodySmall),
                    onTap: () => context.push('/auth/language'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.accessibility_new, color: AppColors.primary),
                    title: Text('Accessibility Options', style: AppTypography.titleMedium),
                    subtitle: Text('Large Fonts & High Contrast', style: AppTypography.bodySmall),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Account Management', style: AppTypography.titleLarge),
            const SizedBox(height: 12),
            GlassCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.switch_account, color: AppColors.secondaryDark),
                    title: Text('Change Persona / Role', style: AppTypography.titleMedium),
                    onTap: () => context.push('/auth/role'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppColors.error),
                    title: Text('Log Out', style: AppTypography.titleMedium.copyWith(color: AppColors.error)),
                    onTap: () => context.go('/auth/login'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
