import 'package:flutter/material.dart';
import 'package:suresend/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppTheme.spacingM),
            GestureDetector(
              onTap: () {
                // handle avatar edit
              },
              child: CircleAvatar(
                radius: 52,
                backgroundColor: Colors.grey[200],
                backgroundImage:
                    const AssetImage('assets/images/avatar_placeholder.png'),
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              'Nice Name',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingXs),
            _KycChip(status: 'Verified'),
            const SizedBox(height: AppTheme.spacingL),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  children: [
                    _ProfileField(label: 'Full Name', value: 'Nice Name'),
                    const Divider(),
                    _ProfileField(label: 'Email', value: 'you@example.com'),
                    const Divider(),
                    _ProfileField(label: 'Phone', value: '+233 24 000 0000'),
                    const Divider(),
                    _ProfileField(label: 'Country', value: 'Ghana'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // navigate to edit profile
                    },
                    child: const Text('Edit Profile'),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // logout
                    },
                    child: const Text('Logout'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _KycChip extends StatelessWidget {
  final String status;

  const _KycChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final isVerified = status.toLowerCase() == 'verified';
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingXs,
      ),
      decoration: BoxDecoration(
        color: isVerified
            ? Colors.green.withOpacity(0.12)
            : Colors.orange.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVerified ? Icons.check_circle_rounded : Icons.info_rounded,
            color: isVerified ? Colors.green : Colors.orange,
            size: 16,
          ),
          const SizedBox(width: AppTheme.spacingS),
          Text(
            status,
            style: TextStyle(
              color: isVerified ? Colors.green : Colors.orange,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
