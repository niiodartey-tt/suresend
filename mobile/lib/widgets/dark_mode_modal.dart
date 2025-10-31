import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/theme.dart';

/// Dark Mode Enabled Modal
/// Matches ui_references/dark_mode_eneabled.png
class DarkModeModal extends StatelessWidget {
  const DarkModeModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.darkBackground.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.dark_mode,
                size: 32,
                color: AppColors.darkBackground,
              ),
            ),
            const SizedBox(height: AppTheme.spacing16),

            // Title
            Text(
              'Dark Mode Enabled',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacing8),

            // Message
            Text(
              'Your app theme has been switched to dark mode. You can change it anytime in settings.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacing24),

            // Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Got it'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper function to show dark mode modal
Future<void> showDarkModeModal(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => const DarkModeModal(),
  );
}
