import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../config/app_colors.dart';
import '../../theme/app_theme.dart';
import '../common/app_modal.dart';

/// OTP Verification Modal following claude_code_prompt.md specifications
/// Semi-transparent dark overlay with centered white card
class OTPVerificationModal extends StatefulWidget {
  final String email;
  final Function(String) onVerify;
  final VoidCallback? onResend;

  const OTPVerificationModal({
    super.key,
    required this.email,
    required this.onVerify,
    this.onResend,
  });

  @override
  State<OTPVerificationModal> createState() => _OTPVerificationModalState();

  /// Show OTP modal dialog
  static Future<String?> show(
    BuildContext context, {
    required String email,
  }) {
    return AppModal.showDialog<String>(
      context,
      child: OTPVerificationModal(
        email: email,
        onVerify: (otp) {
          Navigator.of(context).pop(otp);
        },
      ),
    );
  }
}

class _OTPVerificationModalState extends State<OTPVerificationModal> {
  final _otpController = TextEditingController();
  int _resendCountdown = 55;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
        _startCountdown();
      }
    });
  }

  void _handleVerify() {
    if (_otpController.text.length == 6) {
      widget.onVerify(_otpController.text);
    }
  }

  void _handleResend() {
    if (_resendCountdown > 0 || _isResending) return;

    setState(() {
      _isResending = true;
      _resendCountdown = 55;
    });

    widget.onResend?.call();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
        _startCountdown();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: TextStyle(
        fontSize: AppTheme.fontSizePageTitle,
        fontWeight: AppTheme.fontWeightBold,
        color: AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: AppColors.mutedBlue),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
    );

    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header (navy blue bar)
          ModalHeader(
            title: 'Verify OTP',
            subtitle: 'Enter the code sent to your email',
            leading: const Icon(
              Icons.mail_outline,
              color: Colors.white,
              size: 24,
            ),
            onClose: () => Navigator.of(context).pop(),
          ),

          // Body (white)
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacing24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // "Code sent to" label
                Text(
                  'Code sent to',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    fontWeight: AppTheme.fontWeightRegular,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacing4),

                // Email display
                Text(
                  widget.email,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeBody,
                    fontWeight: AppTheme.fontWeightSemibold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacing16),

                // Helper text
                Text(
                  'Please check your email inbox for the verification code',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    fontWeight: AppTheme.fontWeightRegular,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacing24),

                // OTP Input - 6 digit code entry
                Pinput(
                  controller: _otpController,
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: defaultPinTheme,
                  autofocus: true,
                  onCompleted: (pin) {
                    // Auto-verify when 6 digits entered
                    _handleVerify();
                  },
                ),
                const SizedBox(height: AppTheme.spacing16),

                // Demo text
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing12),
                  decoration: BoxDecoration(
                    color: AppColors.accentBackground,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Text(
                    'For demo purposes, use OTP: 123456',
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeSmall,
                      fontWeight: AppTheme.fontWeightRegular,
                      color: AppColors.accentForeground,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing16),

                // Resend OTP
                Center(
                  child: _resendCountdown > 0
                      ? Text(
                          'Resend OTP in ${_resendCountdown}s',
                          style: TextStyle(
                            fontSize: AppTheme.fontSizeSmall,
                            fontWeight: AppTheme.fontWeightRegular,
                            color: AppColors.textSecondary,
                          ),
                        )
                      : TextButton(
                          onPressed: _isResending ? null : _handleResend,
                          child: Text(
                            _isResending ? 'Sending...' : 'Resend OTP',
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeBody,
                              fontWeight: AppTheme.fontWeightMedium,
                              color: _isResending
                                  ? AppColors.textSecondary
                                  : AppColors.primary,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: AppTheme.spacing24),

                // Verify button (light blue, full width)
                SizedBox(
                  height: AppTheme.buttonHeight,
                  child: ElevatedButton(
                    onPressed: _handleVerify,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Verify',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeBody,
                        fontWeight: AppTheme.fontWeightSemibold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacing12),

                // Cancel button (white/gray outline, full width)
                SizedBox(
                  height: AppTheme.buttonHeight,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(
                        color: AppColors.mutedBlue,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeBody,
                        fontWeight: AppTheme.fontWeightSemibold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
