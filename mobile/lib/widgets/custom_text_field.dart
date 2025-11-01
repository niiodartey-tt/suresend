import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/app_colors.dart';
import '../theme/app_theme.dart';

/// Custom TextField Widget following claude_code_prompt.md specifications
/// Input fields have left-aligned icons (20px), proper padding, and light gray borders
class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final String? helperText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final TextCapitalization textCapitalization;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.helperText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
    this.inputFormatters,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: AppTheme.fontSizeBody,
            fontWeight: AppTheme.fontWeightMedium,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          enabled: widget.enabled,
          validator: widget.validator,
          onChanged: widget.onChanged,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          maxLines: widget.maxLines,
          textCapitalization: widget.textCapitalization,
          style: TextStyle(
            fontSize: AppTheme.fontSizeBody,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    size: 20,
                    color: AppColors.textSecondary,
                  )
                : null,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
            counterText: '',
          ),
        ),
        if (widget.helperText != null) ...[
          const SizedBox(height: AppTheme.spacing4),
          Text(
            widget.helperText!,
            style: TextStyle(
              fontSize: AppTheme.fontSizeSmall,
              fontWeight: AppTheme.fontWeightRegular,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
