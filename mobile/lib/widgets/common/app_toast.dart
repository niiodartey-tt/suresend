import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../theme/app_theme.dart';

/// Toast notification widget following claude_code_prompt.md specifications
/// Shows success/error/info messages at the bottom of screen
class AppToast {
  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.success,
    Duration duration = const Duration(seconds: 3),
    IconData? icon,
  }) {
    Color backgroundColor;
    Color textColor;
    IconData toastIcon;

    switch (type) {
      case ToastType.success:
        backgroundColor = AppColors.success;
        textColor = Colors.white;
        toastIcon = icon ?? Icons.check_circle;
        break;
      case ToastType.error:
        backgroundColor = AppColors.error;
        textColor = Colors.white;
        toastIcon = icon ?? Icons.error;
        break;
      case ToastType.warning:
        backgroundColor = AppColors.warning;
        textColor = Colors.white;
        toastIcon = icon ?? Icons.warning;
        break;
      case ToastType.info:
        backgroundColor = AppColors.lightBlue;
        textColor = Colors.white;
        toastIcon = icon ?? Icons.info;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              toastIcon,
              color: textColor,
              size: AppTheme.iconSizeRegular,
            ),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: AppTheme.fontSizeBody,
                  fontWeight: AppTheme.fontWeightMedium,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        margin: const EdgeInsets.all(AppTheme.spacing16),
        duration: duration,
        elevation: 4,
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    show(context, message: message, type: ToastType.success);
  }

  static void showError(BuildContext context, String message) {
    show(context, message: message, type: ToastType.error);
  }

  static void showWarning(BuildContext context, String message) {
    show(context, message: message, type: ToastType.warning);
  }

  static void showInfo(BuildContext context, String message) {
    show(context, message: message, type: ToastType.info);
  }
}

enum ToastType {
  success,
  error,
  warning,
  info,
}
