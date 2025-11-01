import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suresend/theme/app_theme.dart';
import 'package:suresend/theme/app_colors.dart';
import 'package:suresend/providers/transaction_provider.dart';
import '../transactions/transaction_detail_screen.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  _DealsScreenState createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Fetch transactions when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().fetchTransactions(refresh: true);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
      case 'completed':
        return Colors.green.shade700;
      case 'In Escrow':
      case 'in_escrow':
      case 'escrow':
        return AppColors.primary;
      case 'In Progress':
      case 'in_progress':
      case 'pending_confirmation':
        return Colors.orange.shade700;
      case 'Pending':
      case 'pending':
        return Colors.grey.shade700;
      case 'Disputed':
      case 'disputed':
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }

  String _formatStatus(String status) {
    switch (status) {
      case 'in_escrow':
        return 'In Escrow';
      case 'in_progress':
      case 'pending_confirmation':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'disputed':
        return 'Disputed';
      case 'cancelled':
        return 'Cancelled';
      case 'pending':
        return 'Pending';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Deals'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search deals...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value.toLowerCase());
              },
            ),
          ),

          // Deals List
          Expanded(
            child: Consumer<TransactionProvider>(
              builder: (context, transactionProvider, child) {
                // Filter transactions based on search query
                final allTransactions = transactionProvider.transactions;
                final transactions = _searchQuery.isEmpty
                    ? allTransactions
                    : allTransactions.where((t) {
                        return t.description.toLowerCase().contains(_searchQuery) ||
                               t.id.toLowerCase().contains(_searchQuery) ||
                               t.status.toLowerCase().contains(_searchQuery);
                      }).toList();

                final isLoading = transactionProvider.isLoading;
                final hasError = transactionProvider.error != null;

                // Loading state
                if (isLoading && transactions.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Error state
                if (hasError && transactions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load deals',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          transactionProvider.error ?? 'Unknown error',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            transactionProvider.fetchTransactions(refresh: true);
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                // Empty state
                if (transactions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'No deals found'
                              : 'No deals yet',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'Try adjusting your search'
                              : 'Create your first deal to get started',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (_searchQuery.isEmpty)
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(context, '/create-transaction');
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Create Deal'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }

                // List of deals
                return RefreshIndicator(
                  onRefresh: () => transactionProvider.fetchTransactions(refresh: true),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];

                      // Determine role based on transaction data
                      // For demo purposes, assuming buyer role if userId matches
                      final roleIsBuyer = true; // This should be determined by comparing userId with transaction buyer/seller

                      return Card(
                        margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                        ),
                        elevation: 2,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransactionDetailScreen(
                                  transactionId: transaction.id,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(AppTheme.spacingM),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(AppTheme.spacingS),
                                      decoration: BoxDecoration(
                                        color: roleIsBuyer
                                            ? AppColors.primary.withOpacity(0.08)
                                            : Colors.green.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                                      ),
                                      child: Icon(
                                        Icons.handshake_rounded,
                                        color: roleIsBuyer ? AppColors.primary : Colors.green,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: AppTheme.spacingM),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            transaction.description,
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodyLarge
                                                                ?.copyWith(
                                                                  fontWeight: FontWeight.w700,
                                                                ),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                          decoration: BoxDecoration(
                                                            color: roleIsBuyer
                                                                ? AppColors.primary.withOpacity(0.08)
                                                                : Colors.green.withOpacity(0.08),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Text(
                                                            roleIsBuyer ? 'Buying' : 'Selling',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: roleIsBuyer
                                                                  ? AppColors.primary
                                                                  : Colors.green,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      transaction.id,
                                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                        color: Colors.grey.shade600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    '${roleIsBuyer ? "-" : "+"}\$${transaction.amount.toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                      color: roleIsBuyer ? Colors.red : Colors.green,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: AppTheme.spacingM),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 6,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: _getStatusColor(transaction.status)
                                                          .withOpacity(0.1),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Text(
                                                      _formatStatus(transaction.status),
                                                      style: TextStyle(
                                                        color: _getStatusColor(transaction.status),
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: AppTheme.spacingM),
                                                  Text(
                                                    _formatDate(transaction.createdAt),
                                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                      color: Colors.grey.shade600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-transaction');
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
