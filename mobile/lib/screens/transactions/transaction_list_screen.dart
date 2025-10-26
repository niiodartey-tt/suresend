import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/transaction.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/skeleton_loader.dart';
import '../../widgets/error_retry_widget.dart';
import '../../utils/animation_helpers.dart';
import 'transaction_detail_screen.dart';
import 'create_transaction_screen.dart';

class TransactionListScreen extends StatefulWidget {
  final String?
      role; // Optional initial role filter: 'buyer', 'seller', 'rider'

  const TransactionListScreen({super.key, this.role});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  String? _selectedStatus;
  String? _selectedRole;
  final ScrollController _scrollController = ScrollController();
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.role; // Initialize with provided role
    _loadTransactions();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final provider = context.read<TransactionProvider>();
      if (!provider.isLoading && provider.hasMore) {
        _loadMore();
      }
    }
  }

  Future<void> _loadTransactions() async {
    final provider = context.read<TransactionProvider>();
    await provider.fetchTransactions(
      refresh: true,
      status: _selectedStatus,
      role: _selectedRole,
    );
    await provider.fetchStats();

    if (mounted) {
      setState(() => _isInitialLoading = false);
    }
  }

  Future<void> _loadMore() async {
    final provider = context.read<TransactionProvider>();
    await provider.fetchTransactions(
      status: _selectedStatus,
      role: _selectedRole,
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Filter Transactions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _selectedStatus == null,
                  onSelected: (selected) {
                    setState(() => _selectedStatus = null);
                    Navigator.pop(context);
                    _loadTransactions();
                  },
                ),
                FilterChip(
                  label: const Text('In Escrow'),
                  selected: _selectedStatus == 'in_escrow',
                  onSelected: (selected) {
                    setState(() => _selectedStatus = 'in_escrow');
                    Navigator.pop(context);
                    _loadTransactions();
                  },
                ),
                FilterChip(
                  label: const Text('Completed'),
                  selected: _selectedStatus == 'completed',
                  onSelected: (selected) {
                    setState(() => _selectedStatus = 'completed');
                    Navigator.pop(context);
                    _loadTransactions();
                  },
                ),
                FilterChip(
                  label: const Text('Disputed'),
                  selected: _selectedStatus == 'disputed',
                  onSelected: (selected) {
                    setState(() => _selectedStatus = 'disputed');
                    Navigator.pop(context);
                    _loadTransactions();
                  },
                ),
                FilterChip(
                  label: const Text('Cancelled'),
                  selected: _selectedStatus == 'cancelled',
                  onSelected: (selected) {
                    setState(() => _selectedStatus = 'cancelled');
                    Navigator.pop(context);
                    _loadTransactions();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Role', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _selectedRole == null,
                  onSelected: (selected) {
                    setState(() => _selectedRole = null);
                    Navigator.pop(context);
                    _loadTransactions();
                  },
                ),
                FilterChip(
                  label: const Text('As Buyer'),
                  selected: _selectedRole == 'buyer',
                  onSelected: (selected) {
                    setState(() => _selectedRole = 'buyer');
                    Navigator.pop(context);
                    _loadTransactions();
                  },
                ),
                FilterChip(
                  label: const Text('As Seller'),
                  selected: _selectedRole == 'seller',
                  onSelected: (selected) {
                    setState(() => _selectedRole = 'seller');
                    Navigator.pop(context);
                    _loadTransactions();
                  },
                ),
                FilterChip(
                  label: const Text('As Rider'),
                  selected: _selectedRole == 'rider',
                  onSelected: (selected) {
                    setState(() => _selectedRole = 'rider');
                    Navigator.pop(context);
                    _loadTransactions();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final authProvider = context.watch<AuthProvider>();
    final transactions = transactionProvider.transactions;
    final stats = transactionProvider.stats;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadTransactions,
        child: Column(
          children: [
            // Stats summary
            if (stats != null)
              Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Purchases',
                        value: stats.purchases.total.toString(),
                        subtitle:
                            'GHS ${stats.purchases.totalSpent.toStringAsFixed(2)}',
                        icon: Icons.shopping_bag,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatCard(
                        title: 'Sales',
                        value: stats.sales.total.toString(),
                        subtitle:
                            'GHS ${stats.sales.totalEarned.toStringAsFixed(2)}',
                        icon: Icons.sell,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatCard(
                        title: 'Deliveries',
                        value: stats.deliveries.total.toString(),
                        subtitle: 'Completed',
                        icon: Icons.delivery_dining,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),

            // Active filters
            if (_selectedStatus != null || _selectedRole != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Text('Filters: ',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    if (_selectedStatus != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: Text(_selectedStatus!),
                          onDeleted: () {
                            setState(() => _selectedStatus = null);
                            _loadTransactions();
                          },
                        ),
                      ),
                    if (_selectedRole != null)
                      Chip(
                        label: Text(_selectedRole!),
                        onDeleted: () {
                          setState(() => _selectedRole = null);
                          _loadTransactions();
                        },
                      ),
                  ],
                ),
              ),

            // Transaction list
            Expanded(
              child: _isInitialLoading && transactions.isEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: 5,
                      itemBuilder: (context, index) =>
                          const SkeletonTransactionCard(),
                    )
                  : transactions.isEmpty && !transactionProvider.isLoading
                      ? const EmptyStateWidget.transactions()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: transactions.length +
                              (transactionProvider.hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == transactions.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final transaction = transactions[index];
                            return AnimatedListItem(
                              index: index,
                              child: _TransactionCard(
                                transaction: transaction,
                                currentUserId: authProvider.user!.id,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TransactionDetailScreen(
                                        transactionId: transaction.id,
                                      ),
                                    ),
                                  );
                                  _loadTransactions();
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: authProvider.user?.isBuyer == true
          ? FloatingActionButton.extended(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateTransactionScreen(),
                  ),
                );
                if (result == true) {
                  _loadTransactions();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('New Transaction'),
            )
          : null,
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final String currentUserId;
  final VoidCallback onTap;

  const _TransactionCard({
    required this.transaction,
    required this.currentUserId,
    required this.onTap,
  });

  String _getRole() {
    if (transaction.buyer.id == currentUserId) return 'Buyer';
    if (transaction.seller.id == currentUserId) return 'Seller';
    if (transaction.rider?.id == currentUserId) return 'Rider';
    return '';
  }

  Color _getStatusColor() {
    switch (transaction.status) {
      case 'in_escrow':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'disputed':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      case 'refunded':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');
    final isBuyer = transaction.buyer.id == currentUserId;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      transaction.statusDisplay,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getRole(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'GHS ${transaction.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                transaction.description,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.receipt, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    transaction.transactionRef,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    isBuyer ? Icons.sell : Icons.shopping_bag,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isBuyer
                        ? 'Seller: ${transaction.seller.fullName}'
                        : 'Buyer: ${transaction.buyer.fullName}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time,
                      size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    dateFormat.format(transaction.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
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
}
