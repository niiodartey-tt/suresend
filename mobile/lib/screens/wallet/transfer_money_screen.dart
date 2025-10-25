import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet_provider.dart';
import '../../config/theme.dart';
import '../../services/transaction_service.dart';
import '../../widgets/skeleton_loader.dart';
import '../../widgets/error_retry_widget.dart';
import '../../utils/animation_helpers.dart';
import '../transactions/transaction_success_screen.dart';

class TransferMoneyScreen extends StatefulWidget {
  const TransferMoneyScreen({Key? key}) : super(key: key);

  @override
  State<TransferMoneyScreen> createState() => _TransferMoneyScreenState();
}

class _TransferMoneyScreenState extends State<TransferMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _transactionService = TransactionService();

  bool _isLoading = false;
  bool _isVerifyingUser = false;
  Map<String, dynamic>? _recipientDetails;

  @override
  void dispose() {
    _usernameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _verifyUsername() async {
    final searchQuery = _usernameController.text.trim();
    if (searchQuery.isEmpty) {
      return;
    }

    setState(() {
      _isVerifyingUser = true;
      _recipientDetails = null;
    });

    try {
      // Search for user by username or phone number
      final result = await _transactionService.searchUsers(query: searchQuery);

      if (result['success'] && result['data']['users'].isNotEmpty) {
        final user = result['data']['users'][0]; // Take first match

        setState(() {
          _recipientDetails = {
            'id': user['id'],
            'username': user['username'],
            'fullName': user['fullName'],
            'phoneNumber': user['phoneNumber'],
            'isVerified': user['isVerified'],
            'verified': true,
          };
          _isVerifyingUser = false;
        });
      } else {
        setState(() {
          _isVerifyingUser = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User not found: $searchQuery'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isVerifyingUser = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error searching for user: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showConfirmationDialog() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_recipientDetails == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please verify the recipient username first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final amount = double.parse(_amountController.text);
    final username = _usernameController.text.trim();
    final description = _descriptionController.text.trim();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Transfer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'You are about to transfer:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _ConfirmationRow(
              label: 'Amount',
              value: '₵ ${amount.toStringAsFixed(2)}',
              valueColor: AppTheme.primaryColor,
              valueBold: true,
            ),
            const SizedBox(height: 8),
            _ConfirmationRow(
              label: 'To',
              value: username,
            ),
            const SizedBox(height: 8),
            _ConfirmationRow(
              label: 'Recipient Name',
              value: _recipientDetails!['fullName'] ?? 'N/A',
            ),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 8),
              _ConfirmationRow(
                label: 'Description',
                value: description,
              ),
            ],
            const SizedBox(height: 16),
            const Text(
              'This action cannot be undone.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _handleTransfer();
    }
  }

  Future<void> _handleTransfer() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final walletProvider = Provider.of<WalletProvider>(context, listen: false);

      final result = await walletProvider.transferFunds(
        recipientUsername: _usernameController.text.trim(),
        amount: double.parse(_amountController.text),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        if (mounted) {
          final amount = double.parse(_amountController.text);
          final description = _descriptionController.text.trim();

          // Navigate to success screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionSuccessScreen(
                title: 'Transfer Successful!',
                message: 'Your money has been sent successfully.',
                amount: '₵ ${amount.toStringAsFixed(2)}',
                reference: result['data']?['transaction']?['reference'],
                details: {
                  'Recipient': _recipientDetails!['fullName'],
                  'Username': '@${_recipientDetails!['username']}',
                  if (description.isNotEmpty) 'Description': description,
                },
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Transfer failed'),
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
        title: const Text('Transfer Money'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        message: 'Processing transfer...',
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
                          color: AppTheme.primaryColor.withOpacity(0.1),
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
                                  style: const TextStyle(
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

                // Recipient Username
              const Text(
                'Recipient Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username or Phone Number',
                  hintText: 'Enter username or phone number',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person_search),
                  suffixIcon: _isVerifyingUser
                      ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : _recipientDetails != null
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: _verifyUsername,
                            ),
                ),
                onChanged: (value) {
                  // Reset recipient details when username changes
                  if (_recipientDetails != null) {
                    setState(() {
                      _recipientDetails = null;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter recipient username';
                  }
                  return null;
                },
              ),

              // Recipient Details Display
              if (_recipientDetails != null) ...[
                const SizedBox(height: 12),
                AnimationHelpers.slideInFromBottom(
                  child: Card(
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green.shade700),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _recipientDetails!['fullName'] ?? 'Unknown',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '@${_recipientDetails!['username']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // Amount
              const Text(
                'Transfer Amount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
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
                  helperText: 'Minimum transfer: GHS 1.00',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null) {
                    return 'Please enter a valid amount';
                  }
                  if (amount < 1) {
                    return 'Minimum transfer amount is GHS 1.00';
                  }
                  if (wallet != null && amount > wallet.balance) {
                    return 'Insufficient balance';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description (Optional)
              const Text(
                'Description (Optional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Add a note for this transfer',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 3,
                maxLength: 200,
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
                          'Transfers are instant and cannot be reversed. Please verify the recipient details carefully.',
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

              // Transfer Button
              ElevatedButton(
                onPressed: _isLoading ? null : _showConfirmationDialog,
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
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Transfer Money',
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
    );
  }
}

class _ConfirmationRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool valueBold;

  const _ConfirmationRow({
    Key? key,
    required this.label,
    required this.value,
    this.valueColor,
    this.valueBold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: valueBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}
