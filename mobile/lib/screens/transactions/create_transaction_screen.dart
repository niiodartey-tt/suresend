import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/transaction.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/skeleton_loader.dart';
import '../../widgets/error_retry_widget.dart';
import '../../utils/animation_helpers.dart';
import 'transaction_success_screen.dart';

class CreateTransactionScreen extends StatefulWidget {
  const CreateTransactionScreen({super.key});

  @override
  State<CreateTransactionScreen> createState() =>
      _CreateTransactionScreenState();
}

class _CreateTransactionScreenState extends State<CreateTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _searchController = TextEditingController();

  UserSearchResult? _selectedSeller;
  UserSearchResult? _selectedRider;
  String _paymentMethod = 'wallet';
  bool _isSearching = false;
  bool _isCreating = false;
  List<UserSearchResult> _searchResults = [];

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchUsers(String query, String userType) async {
    if (query.length < 2) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      final transactionProvider = context.read<TransactionProvider>();
      final results = await transactionProvider.searchUsers(
        query: query,
        userType: userType,
      );

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Search failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _createTransaction() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSeller == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a seller')),
      );
      return;
    }

    setState(() => _isCreating = true);

    final transactionProvider = context.read<TransactionProvider>();
    final authProvider = context.read<AuthProvider>();

    final result = await transactionProvider.createEscrow(
      sellerId: _selectedSeller!.id,
      amount: double.parse(_amountController.text),
      description: _descriptionController.text,
      paymentMethod: _paymentMethod,
      riderId: _selectedRider?.id,
    );

    if (mounted) setState(() => _isCreating = false);

    if (!mounted) return;

    if (result['success']) {
      // Refresh user profile to get updated wallet balance
      await authProvider.refreshProfile();

      // Refresh transactions and stats
      await transactionProvider.fetchTransactions(refresh: true);
      await transactionProvider.fetchStats();

      if (!mounted) return;

      // Get transaction data from result
      final transactionData = result['data']['transaction'];
      final amount = double.parse(_amountController.text);
      final commission = transactionData['commission'] ?? (amount * 0.02);

      // Navigate to success screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionSuccessScreen(
            title: 'Escrow Created Successfully!',
            message:
                'Your escrow payment has been secured. The funds will be released when you confirm delivery.',
            amount: '₵ ${amount.toStringAsFixed(2)}',
            reference: transactionData['transactionRef'] ??
                transactionData['transaction_ref'],
            details: {
              'Description': _descriptionController.text,
              'Seller': _selectedSeller!.fullName,
              'Commission': '₵ ${commission.toStringAsFixed(2)}',
              'Total Paid': '₵ ${(amount + commission).toStringAsFixed(2)}',
              'Payment Method': _paymentMethod == 'wallet' ? 'Wallet' : 'Other',
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error'] ?? 'Failed to create transaction'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSellerSearch() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) => Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Search Sellers',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by username or name',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: _isSearching
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : null,
                    ),
                    onChanged: (value) async {
                      await _searchUsers(value, 'seller');
                      setModalState(() {}); // Rebuild the modal
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _searchResults.isEmpty && !_isSearching
                        ? const Center(
                            child: Text(
                              'Search for sellers...',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final seller = _searchResults[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue.shade100,
                                    child: Text(
                                      seller.username[0].toUpperCase(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(seller.fullName),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('@${seller.username}'),
                                      if (seller.isVerified)
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.verified,
                                              size: 14,
                                              color: Colors.blue.shade700,
                                            ),
                                            const SizedBox(width: 4),
                                            const Text(
                                              'Verified',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  trailing: seller.kycStatus == 'approved'
                                      ? const Icon(Icons.check_circle,
                                          color: Colors.green)
                                      : null,
                                  onTap: () {
                                    setState(() {
                                      _selectedSeller = seller;
                                      _searchController.clear();
                                      _searchResults = [];
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Escrow Transaction'),
        centerTitle: true,
      ),
      body: LoadingOverlay(
        isLoading: _isCreating,
        message: 'Creating escrow transaction...',
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info card
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Create a secure escrow transaction. Funds are held safely until delivery is confirmed.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Seller selection
                const Text(
                  'Select Seller',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _showSellerSearch,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_search,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _selectedSeller != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedSeller!.fullName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '@${_selectedSeller!.username}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  'Tap to search sellers',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                        ),
                        Icon(Icons.arrow_forward_ios,
                            size: 16, color: Colors.grey.shade400),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Amount
                const Text(
                  'Amount (GHS)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    hintText: '0.00',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    helperText: 'Platform commission: 2%',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Please enter a valid amount';
                    }
                    if (amount < 1) {
                      return 'Minimum amount is GHS 1.00';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Description
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  maxLength: 500,
                  decoration: InputDecoration(
                    hintText: 'What are you purchasing?',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    if (value.length < 5) {
                      return 'Description must be at least 5 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Payment Method
                const Text(
                  'Payment Method',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'wallet',
                      label: Text('Wallet'),
                      icon: Icon(Icons.account_balance_wallet),
                    ),
                    ButtonSegment(
                      value: 'momo',
                      label: Text('MoMo'),
                      icon: Icon(Icons.phone_android),
                    ),
                    ButtonSegment(
                      value: 'card',
                      label: Text('Card'),
                      icon: Icon(Icons.credit_card),
                    ),
                  ],
                  selected: {_paymentMethod},
                  onSelectionChanged: (Set<String> selection) {
                    setState(() => _paymentMethod = selection.first);
                  },
                ),
                const SizedBox(height: 32),

                // Commission info
                if (_amountController.text.isNotEmpty)
                  Builder(
                    builder: (context) {
                      final itemPrice =
                          double.tryParse(_amountController.text) ?? 0;
                      final commission = itemPrice * 0.02;
                      final totalToPay = itemPrice + commission;

                      return Card(
                        color: Colors.grey.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Item Price'),
                                  Text(
                                    'GHS ${itemPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Platform Fee (2%)'),
                                  Text(
                                    '+ GHS ${commission.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.orange.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'You Pay',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'GHS ${totalToPay.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.green.shade200),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline,
                                        size: 16, color: Colors.green.shade700),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Seller receives full GHS ${itemPrice.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.green.shade700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 32),

                // Create button
                ElevatedButton(
                  onPressed:
                      transactionProvider.isLoading ? null : _createTransaction,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: transactionProvider.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Create Escrow Transaction',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
