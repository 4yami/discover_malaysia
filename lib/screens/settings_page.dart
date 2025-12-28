import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_config.dart';
import '../providers/settings_provider.dart';
import '../core/utils/ui_helpers.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // ============ Display Section ============
          _buildSectionHeader(context, 'Display'),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark Mode'),
            subtitle: const Text('Use dark theme'),
            value: settings.isDarkMode,
            onChanged: settings.setDarkMode,
          ),
          const Divider(),



          // ============ Privacy Section ============
          _buildSectionHeader(context, 'Privacy'),
          SwitchListTile(
            secondary: const Icon(Icons.location_on_outlined),
            title: const Text('Location Services'),
            subtitle: const Text('Allow app to access your location'),
            value: settings.locationEnabled,
            onChanged: settings.setLocationEnabled,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.analytics_outlined),
            title: const Text('Usage Analytics'),
            subtitle: const Text('Help us improve by sharing anonymous data'),
            value: settings.analyticsEnabled,
            onChanged: settings.setAnalyticsEnabled,
          ),
          const Divider(),

          // ============ About Section ============
          _buildSectionHeader(context, 'About'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('App Version'),
            subtitle: Text(AppConfig.appVersion),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showComingSoon(context),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showComingSoon(context),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showComingSoon(context),
          ),
          const Divider(),

          // ============ Reset Section ============
          Padding(
            padding: const EdgeInsets.all(AppConfig.defaultPadding),
            child: OutlinedButton.icon(
              onPressed: () => _confirmReset(context, settings),
              icon: const Icon(Icons.restore),
              label: const Text('Reset to Defaults'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                side: BorderSide(color: theme.colorScheme.error),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }



  void _showComingSoon(BuildContext context) {
    UIHelpers.showSnackBar(
      context,
      message: 'Coming soon!',
    );
  }

  Future<void> _confirmReset(
      BuildContext context, SettingsProvider settings) async {
    final confirmed = await UIHelpers.showConfirmDialog(
      context,
      title: 'Reset Settings',
      message:
          'Are you sure you want to reset all settings to their default values?',
      confirmLabel: 'Reset',
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      settings.resetToDefaults();
      UIHelpers.showSuccessMessage(context, 'Settings reset to defaults');
    }
  }
}
