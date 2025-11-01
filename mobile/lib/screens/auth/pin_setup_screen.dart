import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:suresend/theme/app_colors.dart';
import 'package:suresend/services/storage_service.dart';

class PinSetupScreen extends StatefulWidget {
  final bool isFirstTimeSetup;
  final VoidCallback? onPinSetupComplete;

  const PinSetupScreen({
    super.key,
    this.isFirstTimeSetup = false,
    this.onPinSetupComplete,
  });

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final _storageService = StorageService();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final _focusNode = FocusNode();
  final _confirmFocusNode = FocusNode();

  bool _isConfirmingPin = false;
  String _firstPin = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    _focusNode.dispose();
    _confirmFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handlePinEntry(String pin) async {
    if (_isLoading) return;

    if (!_isConfirmingPin) {
      // First PIN entry
      setState(() {
        _firstPin = pin;
        _isConfirmingPin = true;
        _pinController.clear();
      });

      // Focus on confirmation field
      await Future.delayed(const Duration(milliseconds: 100));
      _confirmFocusNode.requestFocus();
    } else {
      // Confirmation PIN entry
      if (pin == _firstPin) {
        // PINs match, save it
        setState(() => _isLoading = true);

        try {
          await _storageService.savePin(pin);

          if (mounted) {
            setState(() => _isLoading = false);

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('PIN set up successfully!'),
                backgroundColor: AppColors.success,
                duration: Duration(seconds: 2),
              ),
            );

            // Wait a moment then navigate
            await Future.delayed(const Duration(milliseconds: 500));

            if (mounted) {
              if (widget.onPinSetupComplete != null) {
                widget.onPinSetupComplete!();
              } else {
                Navigator.pop(context, true);
              }
            }
          }
        } catch (e) {
          if (mounted) {
            setState(() => _isLoading = false);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to save PIN: $e'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        }
      } else {
        // PINs don't match
        _confirmPinController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PINs do not match. Please try again.'),
            backgroundColor: AppColors.error,
            duration: Duration(seconds: 2),
          ),
        );

        // Reset to first step
        setState(() {
          _isConfirmingPin = false;
          _firstPin = '';
          _pinController.clear();
        });

        // Focus back on first field
        await Future.delayed(const Duration(milliseconds: 500));
        _focusNode.requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Navy Blue Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (!widget.isFirstTimeSetup)
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      if (!widget.isFirstTimeSetup) const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Set Up Your PIN',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your PIN will be used to confirm transactions and secure actions',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Lock Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_outline,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Instruction Text
                    Text(
                      _isConfirmingPin ? 'Confirm Your PIN' : 'Create a 4-Digit PIN',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _isConfirmingPin
                          ? 'Re-enter your PIN to confirm'
                          : 'Choose a secure PIN you\'ll remember',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 48),

                    // PIN Input
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else if (!_isConfirmingPin)
                      Pinput(
                        controller: _pinController,
                        focusNode: _focusNode,
                        length: 4,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        submittedPinTheme: submittedPinTheme,
                        autofocus: true,
                        obscureText: true,
                        onCompleted: _handlePinEntry,
                      )
                    else
                      Pinput(
                        controller: _confirmPinController,
                        focusNode: _confirmFocusNode,
                        length: 4,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        submittedPinTheme: submittedPinTheme,
                        autofocus: true,
                        obscureText: true,
                        onCompleted: _handlePinEntry,
                      ),

                    const SizedBox(height: 32),

                    // Security Tips
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 20,
                                color: Colors.blue.shade700,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Security Tips',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildSecurityTip('Don\'t use obvious PINs like 1234 or 0000'),
                          const SizedBox(height: 8),
                          _buildSecurityTip('Don\'t share your PIN with anyone'),
                          const SizedBox(height: 8),
                          _buildSecurityTip('Your PIN is stored securely on your device'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Cancel button (only if not first time setup)
                    if (!widget.isFirstTimeSetup && !_isLoading)
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityTip(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle,
          size: 16,
          color: Colors.blue.shade700,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.blue.shade800,
            ),
          ),
        ),
      ],
    );
  }
}
