import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/wallet_provider.dart';
import '../../models/wallet.dart';
import '../../config/theme.dart';
import '../../config/app_colors.dart';

class WalletTransactionsScreen extends StatefulWidget {
  const WalletTransactionsScreen({super.key});

  @override
  State<WalletTransactionsScreen> createState() =>
      _WalletTransactionsScreenState();
}

class _WalletTransactionsScreenState extends State<WalletTransactionsScreen> {
  String _filterType = 'all';

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    await walletProvider.fetchTransactions(refresh: true);
  }

  Future<void> _handleRefresh() async {
    await _loadTransactions();
  }

  List<WalletTransaction> _getFilteredTransactions(
      List<WalletTransaction> transactions) {
    if (_filterType == 'all') {
      return transactions;
    } else if (_filterType == 'credit') {
      return transactions.where((t) => t.isCredit).toList();
    } else {
      return transactions.where((t) => !t.isCredit).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<WalletProvider>(
        builder: (context, walletProvider, child) {
          if (walletProvider.isLoading && walletProvider.transactions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (walletProvider.error != null &&
              walletProvider.transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${walletProvider.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.error),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadTransactions,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final filteredTransactions =
              _getFilteredTransactions(walletProvider.transactions);

          return Column(
            children: [
              // Filter Chips
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: _filterType == 'all',
                      onTap: () {
                        setState(() {
                          _filterType = 'all';
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Credit',
                      isSelected: _filterType == 'credit',
                      onTap: () {
                        setState(() {
                          _filterType = 'credit';
                        });
                      },
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Debit',
                      isSelected: _filterType == 'debit',
                      onTap: () {
                        setState(() {
                          _filterType = 'debit';
                        });
                      },
                      color: AppColors.error,
                    ),
                  ],
                ),
              ),

              // Transactions List
              Expanded(
                child: filteredTransactions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.receipt_long_outlined,
                              size: 64,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _filterType == 'all'
                                  ? 'No transactions yet'
                                  : 'No $_filterType transactions',
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _handleRefresh,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: filteredTransactions.length,
                          itemBuilder: (context, index) {
                            final transaction = filteredTransactions[index];
                            return _TransactionCard(transaction: transaction);
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppTheme.primaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radius2xl),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(AppTheme.radius2xl),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final WalletTransaction transaction;

  const _TransactionCard({
    required this.transaction,
  });

  IconData _getTransactionIcon() {
    switch (transaction.type) {
      case 'credit':
        return Icons.arrow_downward;
      case 'debit':
        return Icons.arrow_upward;
      default:
        return Icons.swap_horiz;
    }
  }

  Color _getTransactionColor() {
    return transaction.isCredit ? AppColors.success : AppColors.error;
  }

  String _getTransactionSign() {
    return transaction.isCredit ? '+' : '-';
  }

  @override
  Widget build(BuildContext context) {
    final color = _getTransactionColor();
    final dateFormat = DateFormat('MMM dd, yyyy - HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _showTransactionDetails(context);
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Icon(
                  _getTransactionIcon(),
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.description,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormat.format(transaction.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (transaction.reference.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Ref: ${transaction.reference}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_getTransactionSign()} ₵${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bal: ₵${transaction.balanceAfter.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransactionDetails(BuildContext context) {
    final dateFormat = DateFormat('MMMM dd, yyyy - HH:mm:ss');

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Text(
                  'Transaction Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Amount
            Center(
              child: Column(
                children: [
                  Text(
                    transaction.isCredit ? 'Received' : 'Sent',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_getTransactionSign()} ₵${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: _getTransactionColor(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Details
            _DetailRow(label: 'Description', value: transaction.description),
            const Divider(height: 24),
            _DetailRow(label: 'Type', value: transaction.type.toUpperCase()),
            const Divider(height: 24),
            _DetailRow(
                label: 'Date', value: dateFormat.format(transaction.createdAt)),
            if (transaction.reference.isNotEmpty) ...[
              const Divider(height: 24),
              _DetailRow(label: 'Reference', value: transaction.reference),
            ],
            const Divider(height: 24),
            _DetailRow(
              label: 'Balance Before',
              value: '₵${transaction.balanceBefore.toStringAsFixed(2)}',
            ),
            const Divider(height: 24),
            _DetailRow(
              label: 'Balance After',
              value: '₵${transaction.balanceAfter.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
