import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet_provider.dart';
import '../../config/theme.dart';
import '../../widgets/skeleton_loader.dart';
import '../../widgets/error_retry_widget.dart';
import '../../utils/animation_helpers.dart';

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

  String _selectedMethod = 'bank_transfer';
  String? _selectedNetwork;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _withdrawalMethods = [
    {
      'id': 'bank_transfer',
      'title': 'Bank Transfer',
      'subtitle': 'Withdraw to your bank account',
      'icon': Icons.account_balance,
    },
    {
      'id': 'mobile_money',
      'title': 'Mobile Money',
      'subtitle': 'Withdraw to your mobile money account',
      'icon': Icons.phone_android,
    },
  ];

  final List<Map<String, String>> _mobileMoneyNetworks = [
    {'id': 'mtn', 'name': 'MTN Mobile Money'},
    {'id': 'vodafone', 'name': 'Vodafone Cash'},
    {'id': 'airteltigo', 'name': 'AirtelTigo Money'},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _accountNumberController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  Future<void> _handleWithdrawal() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedMethod == 'mobile_money' && _selectedNetwork == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a mobile money network')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final walletProvider =
          Provider.of<WalletProvider>(context, listen: false);

      // Construct account details map
      final accountDetails = <String, dynamic>{
        'accountNumber': _accountNumberController.text,
        'accountName': _accountNameController.text,
        if (_selectedNetwork != null) 'network': _selectedNetwork,
      };

      final result = await walletProvider.withdrawFunds(
        amount: double.parse(_amountController.text),
        withdrawalMethod: _selectedMethod,
        accountDetails: accountDetails,
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ??
                  'Withdrawal request submitted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  result['message'] ?? 'Failed to submit withdrawal request'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    final wallet = walletProvider.wallet;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdraw Funds'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        message: 'Processing withdrawal...',
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Available Balance Card
                wallet == null
                    ? const SkeletonLoader.card(height: 100)
                    : AnimationHelpers.fadeIn(
                        child: Card(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Available Balance',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '₵ ${wallet.balance.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 24),

                // Withdrawal Method Selection
                const Text(
                  'Withdrawal Method',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ..._withdrawalMethods.map((method) {
                  return _WithdrawalMethodCard(
                    icon: method['icon'] as IconData,
                    title: method['title'] as String,
                    subtitle: method['subtitle'] as String,
                    isSelected: _selectedMethod == method['id'],
                    onTap: () {
                      setState(() {
                        _selectedMethod = method['id'] as String;
                        if (_selectedMethod == 'bank_transfer') {
                          _selectedNetwork = null;
                        }
                      });
                    },
                  );
                }),
                const SizedBox(height: 24),

                // Mobile Money Network Selection (only if mobile_money is selected)
                if (_selectedMethod == 'mobile_money') ...[
                  const Text(
                    'Select Network',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedNetwork,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Choose mobile money network',
                    ),
                    items: _mobileMoneyNetworks.map((network) {
                      return DropdownMenuItem<String>(
                        value: network['id'],
                        child: Text(network['name']!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedNetwork = value;
                      });
                    },
                    validator: (value) {
                      if (_selectedMethod == 'mobile_money' && value == null) {
                        return 'Please select a network';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Account Number
                TextFormField(
                  controller: _accountNumberController,
                  decoration: InputDecoration(
                    labelText: _selectedMethod == 'bank_transfer'
                        ? 'Account Number'
                        : 'Mobile Money Number',
                    hintText: _selectedMethod == 'bank_transfer'
                        ? 'Enter your account number'
                        : 'Enter your mobile money number',
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(
                      _selectedMethod == 'bank_transfer'
                          ? Icons.account_balance
                          : Icons.phone_android,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter account number';
                    }
                    if (_selectedMethod == 'mobile_money' &&
                        value.length != 10) {
                      return 'Mobile money number must be 10 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Account Name
                TextFormField(
                  controller: _accountNameController,
                  decoration: InputDecoration(
                    labelText: 'Account Name',
                    hintText: _selectedMethod == 'bank_transfer'
                        ? 'Enter account holder name'
                        : 'Enter registered name',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter account name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Amount
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount (GHS)',
                    hintText: '0.00',
                    border: OutlineInputBorder(),
                    prefixText: '₵ ',
                    prefixStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    helperText: 'Minimum withdrawal: GHS 50',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null) {
                      return 'Please enter a valid amount';
                    }
                    if (amount < 50) {
                      return 'Minimum withdrawal amount is GHS 50';
                    }
                    if (wallet != null && amount > wallet.balance) {
                      return 'Insufficient balance';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Information Card
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Withdrawals are processed within 1-3 business days. A processing fee may apply.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleWithdrawal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Submit Withdrawal Request',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WithdrawalMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _WithdrawalMethodCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.1) : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppTheme.primaryColor : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  size: 28,
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
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppTheme.primaryColor : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: AppTheme.primaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
