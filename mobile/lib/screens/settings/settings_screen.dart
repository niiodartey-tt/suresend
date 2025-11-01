import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        children: [
          _buildSectionTitle('Account'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_rounded),
                  title: const Text('Manage Account'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.lock_rounded),
                  title: const Text('Change Password'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          _buildSectionTitle('Payments'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.payment_rounded),
                  title: const Text('Payment Methods'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.history_rounded),
                  title: const Text('Transaction Limits'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          _buildSectionTitle('App Preferences'),
          Card(
            child: Column(
              children: [
                Switch(
                  activeThumbColor: AppTheme.primary, // Instead of activeColor
                  value: _darkMode,
                  onChanged: (value) => setState(() => _darkMode = value),
                ),
                SwitchListTile(
                  title: const Text('Notifications'),
                  value: _notifications,
                  onChanged: (v) => setState(() => _notifications = v),
                ),
                ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: const Text('Language'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
      ),
    );
  }
}
