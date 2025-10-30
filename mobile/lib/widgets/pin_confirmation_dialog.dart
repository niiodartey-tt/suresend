import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:suresend/config/app_colors.dart';
import 'package:suresend/config/theme.dart';

/// PIN Confirmation Dialog
/// Used for confirming sensitive transactions
class PinConfirmationDialog extends StatefulWidget {
  final String action;
  final Map<String, dynamic>? transactionData;
  final Function(String pin) onConfirm;

  const PinConfirmationDialog({
    super.key,
    required this.action,
    this.transactionData,
    required this.onConfirm,
  });

  @override
  State<PinConfirmationDialog> createState() => _PinConfirmationDialogState();

  /// Show the PIN confirmation dialog
  static Future<void> show({
    required BuildContext context,
    required String action,
    Map<String, dynamic>? transactionData,
    required Function(String pin) onConfirm,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.overlay.withValues(alpha: 0.6),
      builder: (context) => PinConfirmationDialog(
        action: action,
        transactionData: transactionData,
        onConfirm: onConfirm,
      ),
    );
  }
}

class _PinConfirmationDialogState extends State<PinConfirmationDialog>
    with SingleTickerProviderStateMixin {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();
  String _errorMessage = '';
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _animationController.forward();

    // Auto-focus PIN input
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String _getActionText() {
    switch (widget.action.toLowerCase()) {
      case 'release':
        return 'Release Funds';
      case 'withdraw':
        return 'Withdraw Funds';
      case 'transfer':
        return 'Transfer Funds';
      case 'create-escrow':
        return 'Create Escrow Transaction';
      default:
        return 'Confirm Action';
    }
  }

  Future<void> _handleConfirm(String pin) async {
    if (pin.length != 4) {
      setState(() {
        _errorMessage = 'Please enter a 4-digit PIN';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Simulate PIN validation
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    // Demo: Accept PIN 1234
    if (pin == '1234') {
      widget.onConfirm(pin);
      Navigator.of(context).pop();
    } else {
      setState(() {
        _errorMessage = 'Incorrect PIN. Please try again.';
        _isLoading = false;
      });
      _pinController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        color: AppColors.inputBackground,
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: AppColors.primary, width: 2),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: AppColors.error, width: 2),
      ),
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with gradient
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppTheme.radiusLg),
                  ),
                ),
                padding: const EdgeInsets.all(AppTheme.spacing24),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primaryForeground.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                      child: const Icon(
                        Icons.lock_outline,
                        color: AppColors.primaryForeground,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: AppTheme.spacing12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Confirm Transaction',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: AppColors.primaryForeground,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Enter your PIN to continue',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.primaryForeground
                                          .withValues(alpha: 0.8),
                                    ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      color: AppColors.primaryForeground,
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacing24),
                child: Column(
                  children: [
                    // Transaction summary card
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacing16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMd),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Action',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                          ),
                          SizedBox(height: AppTheme.spacing4),
                          Text(
                            _getActionText(),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          if (widget.transactionData != null) ...[
                            SizedBox(height: AppTheme.spacing12),
                            const Divider(height: 1),
                            SizedBox(height: AppTheme.spacing12),
                            Text(
                              'Amount',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            SizedBox(height: AppTheme.spacing4),
                            Text(
                              '\$${widget.transactionData!['amount'] ?? '0.00'}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            if (widget.transactionData!['id'] != null) ...[
                              SizedBox(height: AppTheme.spacing12),
                              Text(
                                'Transaction ID',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                              SizedBox(height: AppTheme.spacing4),
                              Text(
                                widget.transactionData!['id'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: AppTheme.spacing24),

                    // PIN input label
                    Text(
                      'Enter 4-Digit PIN',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    SizedBox(height: AppTheme.spacing16),

                    // PIN input
                    Pinput(
                      controller: _pinController,
                      focusNode: _focusNode,
                      length: 4,
                      obscureText: true,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      errorPinTheme: errorPinTheme,
                      enabled: !_isLoading,
                      onCompleted: _handleConfirm,
                      errorText: _errorMessage.isEmpty ? null : _errorMessage,
                    ),
                    SizedBox(height: AppTheme.spacing8),

                    // Demo hint
                    Text(
                      'For demo purposes, use PIN: 1234',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),

                    // Error message
                    if (_errorMessage.isNotEmpty) ...[
                      SizedBox(height: AppTheme.spacing12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing12,
                          vertical: AppTheme.spacing8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.errorLight,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusSm),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 16,
                              color: AppColors.error,
                            ),
                            SizedBox(width: AppTheme.spacing8),
                            Expanded(
                              child: Text(
                                _errorMessage,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.error,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    SizedBox(height: AppTheme.spacing24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isLoading
                                ? null
                                : () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        SizedBox(width: AppTheme.spacing12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ||
                                    _pinController.text.length != 4
                                ? null
                                : () => _handleConfirm(_pinController.text),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primaryForeground,
                                      ),
                                    ),
                                  )
                                : const Text('Confirm'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
