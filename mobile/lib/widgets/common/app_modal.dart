import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../theme/app_theme.dart';

/// Modal dialog widget following claude_code_prompt.md specifications
/// Modals: 16px-20px border radius
/// Semi-transparent dark overlay
class AppModal {
  /// Show a bottom sheet modal
  static Future<T?> showBottomSheet<T>(
    BuildContext context, {
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.card,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppTheme.radiusModal),
            topRight: Radius.circular(AppTheme.radiusModal),
          ),
        ),
        child: child,
      ),
    );
  }

  /// Show a centered dialog modal
  static Future<T?> showDialog<T>(
    BuildContext context, {
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: barrierColor ?? AppColors.overlay,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing24,
              ),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppTheme.radiusModal),
              ),
              child: child,
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
            child: child,
          ),
        );
      },
    );
  }
}

/// Modal header widget with title and close button
class ModalHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onClose;
  final Color? backgroundColor;
  final Widget? leading;

  const ModalHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onClose,
    this.backgroundColor,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radiusModal),
          topRight: Radius.circular(AppTheme.radiusModal),
        ),
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppTheme.spacing12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSectionHeader,
                    fontWeight: AppTheme.fontWeightSemibold,
                    color: backgroundColor == null
                        ? Colors.white
                        : AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppTheme.spacing4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      fontWeight: AppTheme.fontWeightRegular,
                      color: backgroundColor == null
                          ? Colors.white.withOpacity(0.9)
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onClose != null)
            IconButton(
              icon: Icon(
                Icons.close,
                color: backgroundColor == null
                    ? Colors.white
                    : AppColors.textPrimary,
              ),
              onPressed: onClose,
            ),
        ],
      ),
    );
  }
}
