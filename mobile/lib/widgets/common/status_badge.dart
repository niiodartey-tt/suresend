import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../theme/app_theme.dart';

/// Status Badge Widget - Pill-shaped badge for transaction statuses
/// Based on claude_code_prompt.md specifications
class StatusBadge extends StatelessWidget {
  final String status;
  final double? fontSize;
  final EdgeInsets? padding;

  const StatusBadge({
    super.key,
    required this.status,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final statusColors = AppColors.getStatusColors(status);

    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing12,
            vertical: AppTheme.spacing4,
          ),
      decoration: BoxDecoration(
        color: statusColors.background,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(
          color: statusColors.border,
          width: 1,
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: fontSize ?? AppTheme.fontSizeSmall,
          fontWeight: AppTheme.fontWeightMedium,
          color: statusColors.text,
        ),
      ),
    );
  }
}
