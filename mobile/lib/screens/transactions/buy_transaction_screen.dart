import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/theme.dart';

/// Buy Transaction Screen
/// Matches ui_references/buy_transaction.png
class BuyTransactionScreen extends StatefulWidget {
  const BuyTransactionScreen({super.key});

  @override
  State<BuyTransactionScreen> createState() => _BuyTransactionScreenState();
}

class _BuyTransactionScreenState extends State<BuyTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _itemController = TextEditingController();
  final _sellerController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'Physical Product';
  bool _isLoading = false;

  @override
  void dispose() {
    _itemController.dispose();
    _sellerController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateEscrow() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Navigate to success screen
      Navigator.of(context).pushNamed('/escrow-success');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Buy Transaction'),
            Text(
              'You\'re purchasing something',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primaryForeground.withValues(alpha: 0.8),
                  ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.primaryForeground,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // What are you buying?
                Text(
                  'What are you buying?',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _itemController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., iPhone 15 Pro',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the item name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Category
                Text(
                  'Category',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(),
                  items: [
                    'Physical Product',
                    'Digital Product',
                    'Service',
                    'Real Estate',
                    'Vehicle',
                    'Other',
                  ].map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Seller Username/Phone
                Text(
                  'Seller Username/Phone',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _sellerController,
                  decoration: const InputDecoration(
                    hintText: '@username or +1234567890',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter seller username or phone';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  'Enter the username or phone number of the seller',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                ),
                const SizedBox(height: 20),

                // Amount (USD)
                Text(
                  'Amount (USD)',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 16, top: 14),
                      child: Text(
                        '\$',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  'This amount will be held in escrow until you confirm receipt',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                ),
                const SizedBox(height: 20),

                // Description
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Describe what you\'re purchasing...',
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Create Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleCreateEscrow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.7),
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
                        : const Text('Create Escrow Transaction'),
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
