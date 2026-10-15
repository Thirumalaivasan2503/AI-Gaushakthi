import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/cards/login_card.dart';
import '../../../core/services/firebase_service.dart';

/// Application Preferences & Settings Screen
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _selectedTheme = 'System Default';
  String _selectedLanguage = 'English';
  bool _pushNotifications = true;
  bool _weatherAlerts = true;
  bool _syncWifiOnly = false;

  @override
  Widget build(BuildContext context) {
    final firebaseService = ref.watch(firebaseServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Preferences & System Configuration', style: AppTypography.displayMedium.copyWith(color: AppColors.primary)),
              const SizedBox(height: 6),
              Text('Manage theme, language, notifications, offline storage, and account settings.', style: AppTypography.bodyMedium),
              const SizedBox(height: 24),

              // Appearance & Language
              LoginCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Appearance & Localization', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ListTile(
                      leading: const Icon(Icons.palette_outlined, color: AppColors.primary),
                      title: const Text('App Theme'),
                      subtitle: Text(_selectedTheme),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        _showThemeDialog(context);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.language, color: AppColors.primary),
                      title: const Text('Language / மொழி / भाषा'),
                      subtitle: Text(_selectedLanguage),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        _showLanguageDialog(context);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // Notifications & Alerts
              LoginCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Notifications & Cloud Alerts', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      secondary: const Icon(Icons.notifications_active_outlined, color: AppColors.primary),
                      title: const Text('Push Notifications'),
                      subtitle: const Text('Vaccination reminders & disease outbreak warnings'),
                      value: _pushNotifications,
                      activeColor: AppColors.secondary,
                      onChanged: (val) {
                        setState(() => _pushNotifications = val);
                        firebaseService.toggleNotifications(val);
                      },
                    ),
                    const Divider(),
                    SwitchListTile(
                      secondary: const Icon(Icons.cloud_outlined, color: AppColors.primary),
                      title: const Text('Weather & Heat Index Alerts'),
                      subtitle: const Text('Real-time THI heat stress notifications'),
                      value: _weatherAlerts,
                      activeColor: AppColors.secondary,
                      onChanged: (val) => setState(() => _weatherAlerts = val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // Offline Storage & Sync
              LoginCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Offline Storage & Background Sync', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      secondary: const Icon(Icons.wifi_off_outlined, color: AppColors.primary),
                      title: const Text('Sync Over Wi-Fi Only'),
                      subtitle: const Text('Save mobile data in low-reception areas'),
                      value: _syncWifiOnly,
                      activeColor: AppColors.secondary,
                      onChanged: (val) => setState(() => _syncWifiOnly = val),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.storage_outlined, color: AppColors.primary),
                      title: const Text('Offline Database Size'),
                      subtitle: const Text('SQLite Cache: 4.2 MB (48 breed profiles cached)'),
                      trailing: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Offline database cache cleared!')),
                          );
                        },
                        child: const Text('Clear Cache'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // About & Support
              LoginCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('About & System Information', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    const ListTile(
                      leading: Icon(Icons.info_outline, color: AppColors.primary),
                      title: Text('Application Version'),
                      subtitle: Text('v3.2.0 • Production Build (Module 3B)'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.help_outline, color: AppColors.primary),
                      title: const Text('Help & Agronomic Support'),
                      subtitle: const Text('Contact PasuMitra Helpline: 1800-425-9988'),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select App Theme'),
        children: ['System Default', 'Forest Green Dark Mode', 'Warm Gold Light Mode'].map((t) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() => _selectedTheme = t);
              Navigator.pop(context);
            },
            child: Text(t),
          );
        }).toList(),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Language'),
        children: ['English', 'தமிழ் (Tamil)', 'हिंदी (Hindi)'].map((l) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() => _selectedLanguage = l);
              Navigator.pop(context);
            },
            child: Text(l),
          );
        }).toList(),
      ),
    );
  }
}
