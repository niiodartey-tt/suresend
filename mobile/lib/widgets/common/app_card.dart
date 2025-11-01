import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../theme/app_theme.dart';

/// Custom Card Widget following claude_code_prompt.md specifications
/// Card padding: 16px-20px all sides
/// Border radius for cards: 12px-16px
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? borderRadius;
  final Color? color;
  final Color? borderColor;
  final double? borderWidth;
  final VoidCallback? onTap;
  final EdgeInsets? margin;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidget = Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(AppTheme.cardPadding),
      decoration: BoxDecoration(
        color: color ?? AppColors.card,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppTheme.radiusCard,
        ),
        border: borderColor != null
            ? Border.all(
                color: borderColor!,
                width: borderWidth ?? 1.0,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: cardWidget,
      );
    }

    return cardWidget;
  }
}
