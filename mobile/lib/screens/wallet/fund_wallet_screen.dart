import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suresend/theme/app_colors.dart';
import 'package:suresend/theme/app_theme.dart';
import 'package:suresend/widgets/pin_confirmation_modal.dart';
import 'package:suresend/screens/success/transaction_confirmation_screen.dart';

class FundWalletScreen extends StatefulWidget {
  const FundWalletScreen({super.key});

  @override
  State<FundWalletScreen> createState() => _FundWalletScreenState();
}

class _FundWalletScreenState extends State<FundWalletScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _selectedPaymentMethod = '';
  final double _currentBalance = 4500.00; // Demo balance

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleFundWallet() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPaymentMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Show PIN confirmation
    await PinConfirmationModal.show(
      context: context,
      action: 'Fund Wallet',
      amount: '\$${_amountController.text}',
      onConfirm: (pin) {
        // Generate transaction ID
        final transactionId = 'TXN-${DateTime.now().millisecondsSinceEpoch}';
        final now = DateTime.now();
        final date = '${_formatMonth(now.month)} ${now.day}, ${now.year}, ${_formatTime(now)}';

        // Navigate to confirmation screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionConfirmationScreen(
              title: 'Wallet Funded Successfully',
              subtitle: 'Your wallet has been topped up',
              transactionId: transactionId,
              amount: '\$${_amountController.text}',
              recipient: 'SureSend Wallet',
              date: date,
              description: 'Wallet Top-up',
              additionalDetails: {
                'Payment Method': _selectedPaymentMethod,
                'Previous Balance': '\$${_currentBalance.toStringAsFixed(2)}',
                'New Balance': '\$${(_currentBalance + double.parse(_amountController.text)).toStringAsFixed(2)}',
                'Status': 'Completed',
              },
            ),
          ),
        );
      },
    );
  }

  String _formatMonth(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Navy Blue Header with Balance
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
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Fund Wallet',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Current Balance Display
                  Column(
                    children: [
                      const Text(
                        'Current Balance',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${_currentBalance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Form Section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Info Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Add money to your wallet to make secure payments and transfers',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.primary.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Amount Input
                      const Text(
                        'Amount (USD)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          prefixText: '\$ ',
                          helperText: 'Min: \$10.00 • Max: \$10,000.00',
                          helperStyle: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an amount';
                          }
                          final amount = double.tryParse(value);
                          if (amount == null || amount <= 0) {
                            return 'Please enter a valid amount';
                          }
                          if (amount < 10) {
                            return 'Minimum amount is \$10.00';
                          }
                          if (amount > 10000) {
                            return 'Maximum amount is \$10,000.00';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Payment Method
                      const Text(
                        'Payment Method',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // MTN Mobile Money
                      _PaymentMethodCard(
                        icon: Icons.phone_android,
                        title: 'MTN Mobile Money',
                        subtitle: 'Pay with MTN MoMo',
                        color: const Color(0xFFFFCC00),
                        isSelected: _selectedPaymentMethod == 'MTN',
                        onTap: () {
                          setState(() => _selectedPaymentMethod = 'MTN');
                        },
                      ),

                      const SizedBox(height: 12),

                      // Vodafone Cash
                      _PaymentMethodCard(
                        icon: Icons.phone_iphone,
                        title: 'Vodafone Cash',
                        subtitle: 'Pay with Vodafone Cash',
                        color: const Color(0xFFE60000),
                        isSelected: _selectedPaymentMethod == 'Vodafone',
                        onTap: () {
                          setState(() => _selectedPaymentMethod = 'Vodafone');
                        },
                      ),

                      const SizedBox(height: 12),

                      // AirtelTigo Money
                      _PaymentMethodCard(
                        icon: Icons.smartphone,
                        title: 'AirtelTigo Money',
                        subtitle: 'Pay with AirtelTigo',
                        color: const Color(0xFFED1C24),
                        isSelected: _selectedPaymentMethod == 'AirtelTigo',
                        onTap: () {
                          setState(() => _selectedPaymentMethod = 'AirtelTigo');
                        },
                      ),

                      const SizedBox(height: 12),

                      // Card Payment
                      _PaymentMethodCard(
                        icon: Icons.credit_card,
                        title: 'Card Payment',
                        subtitle: 'Pay with debit or credit card',
                        color: AppColors.primary,
                        isSelected: _selectedPaymentMethod == 'Card',
                        onTap: () {
                          setState(() => _selectedPaymentMethod = 'Card');
                        },
                      ),

                      const SizedBox(height: 32),

                      // Fund Button
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _handleFundWallet,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Proceed to Payment',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.1) : AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? color : AppColors.textMuted,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
