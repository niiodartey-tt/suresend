import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suresend/theme/app_colors.dart';
import 'package:suresend/theme/app_theme.dart';
import 'package:suresend/widgets/pin_confirmation_modal.dart';
import 'package:suresend/screens/success/transaction_confirmation_screen.dart';

class WithdrawFundsScreen extends StatefulWidget {
  const WithdrawFundsScreen({super.key});

  @override
  State<WithdrawFundsScreen> createState() => _WithdrawFundsScreenState();
}

class _WithdrawFundsScreenState extends State<WithdrawFundsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountNameController = TextEditingController();

  String _selectedMethod = '';
  final double _availableBalance = 4500.00; // Demo balance

  @override
  void dispose() {
    _amountController.dispose();
    _accountNumberController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  Future<void> _handleWithdrawal() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a withdrawal method'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Show PIN confirmation
    await PinConfirmationModal.show(
      context: context,
      action: 'Withdraw Funds',
      amount: '\$${_amountController.text}',
      onConfirm: (pin) {
        // Generate transaction ID
        final transactionId = 'WTH-${DateTime.now().millisecondsSinceEpoch}';
        final now = DateTime.now();
        final date = '${_formatMonth(now.month)} ${now.day}, ${now.year}, ${_formatTime(now)}';

        // Navigate to confirmation screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionConfirmationScreen(
              title: 'Withdrawal Initiated',
              subtitle: 'Your withdrawal request has been processed',
              transactionId: transactionId,
              amount: '\$${_amountController.text}',
              recipient: _accountNameController.text,
              date: date,
              description: 'Withdrawal',
              additionalDetails: {
                'Withdrawal Method': _selectedMethod,
                'Account Number': _accountNumberController.text,
                'Account Name': _accountNameController.text,
                'Previous Balance': '\$${_availableBalance.toStringAsFixed(2)}',
                'New Balance': '\$${(_availableBalance - double.parse(_amountController.text)).toStringAsFixed(2)}',
                'Status': 'Processing',
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
            // Navy Blue Header with Available Balance
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
                          'Withdraw Funds',
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
                  // Available Balance Display
                  Column(
                    children: [
                      const Text(
                        'Available for Withdrawal',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${_availableBalance.toStringAsFixed(2)}',
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
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Withdrawals are processed within 1-3 business days',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.orange.shade800,
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
                          helperText: 'Min: \$10.00 • Available: \$${_availableBalance.toStringAsFixed(2)}',
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
                          if (amount > _availableBalance) {
                            return 'Insufficient balance';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Withdrawal Method
                      const Text(
                        'Withdrawal Method',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Bank Transfer
                      _WithdrawalMethodCard(
                        icon: Icons.account_balance,
                        title: 'Bank Transfer',
                        subtitle: 'Withdraw to your bank account',
                        color: AppColors.primary,
                        isSelected: _selectedMethod == 'Bank',
                        onTap: () {
                          setState(() => _selectedMethod = 'Bank');
                        },
                      ),

                      const SizedBox(height: 12),

                      // MTN Mobile Money
                      _WithdrawalMethodCard(
                        icon: Icons.phone_android,
                        title: 'MTN Mobile Money',
                        subtitle: 'Withdraw to MTN MoMo',
                        color: const Color(0xFFFFCC00),
                        isSelected: _selectedMethod == 'MTN',
                        onTap: () {
                          setState(() => _selectedMethod = 'MTN');
                        },
                      ),

                      const SizedBox(height: 12),

                      // Vodafone Cash
                      _WithdrawalMethodCard(
                        icon: Icons.phone_iphone,
                        title: 'Vodafone Cash',
                        subtitle: 'Withdraw to Vodafone Cash',
                        color: const Color(0xFFE60000),
                        isSelected: _selectedMethod == 'Vodafone',
                        onTap: () {
                          setState(() => _selectedMethod = 'Vodafone');
                        },
                      ),

                      const SizedBox(height: 12),

                      // AirtelTigo Money
                      _WithdrawalMethodCard(
                        icon: Icons.smartphone,
                        title: 'AirtelTigo Money',
                        subtitle: 'Withdraw to AirtelTigo',
                        color: const Color(0xFFED1C24),
                        isSelected: _selectedMethod == 'AirtelTigo',
                        onTap: () {
                          setState(() => _selectedMethod = 'AirtelTigo');
                        },
                      ),

                      const SizedBox(height: 24),

                      // Account Details (shown when method selected)
                      if (_selectedMethod.isNotEmpty) ...[
                        Text(
                          _selectedMethod == 'Bank' ? 'Bank Account Details' : 'Mobile Money Details',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _accountNumberController,
                          decoration: InputDecoration(
                            labelText: _selectedMethod == 'Bank' ? 'Account Number' : 'Mobile Number',
                            hintText: _selectedMethod == 'Bank' ? 'Enter account number' : 'Enter mobile number',
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return _selectedMethod == 'Bank'
                                  ? 'Please enter account number'
                                  : 'Please enter mobile number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _accountNameController,
                          decoration: InputDecoration(
                            labelText: 'Account Name',
                            hintText: 'Enter account holder name',
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter account name';
                            }
                            return null;
                          },
                        ),
                      ],

                      const SizedBox(height: 32),

                      // Withdraw Button
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _handleWithdrawal,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Withdraw Funds',
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

class _WithdrawalMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _WithdrawalMethodCard({
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
