import 'package:flutter/material.dart';
import 'package:suresend/theme/app_theme.dart';

class TransactionsList extends StatefulWidget {
  const TransactionsList({super.key});

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<Map<String, dynamic>> _transactions = [
    {
      'id': 'TRX-001',
      'date': '25 Oct 2025',
      'amount': 500.0,
      'name': 'John Doe',
      'type': 'Product Sale',
    },
    {
      'id': 'TRX-002',
      'date': '24 Oct 2025',
      'amount': 750.0,
      'name': 'Jane Smith',
      'type': 'Service',
    },
    {
      'id': 'TRX-003',
      'date': '23 Oct 2025',
      'amount': 300.0,
      'name': 'Mike Johnson',
      'type': 'Product Sale',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
              child: Text(
                'Recent Transactions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }
          final transactionIndex = index - 1;
          if (transactionIndex >= _transactions.length) return null;

          final transaction = _transactions[transactionIndex];
          
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.5),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _controller,
                curve: Interval(
                  0.1 * transactionIndex,
                  0.1 * transactionIndex + 0.5,
                  curve: Curves.easeOut,
                ),
              ),
            ),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: Interval(
                    0.1 * transactionIndex,
                    0.1 * transactionIndex + 0.5,
                    curve: Curves.easeOut,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
                child: Card(
                  child: InkWell(
                    onTap: () {
                      // Navigate to transaction details
                    },
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                transaction['id'],
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                transaction['date'],
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spacingM),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    transaction['name'],
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: AppTheme.spacingXs),
                                  Text(
                                    transaction['type'],
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              Text(
                                '\$${transaction['amount'].toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spacingM),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Navigate to transaction details
                              },
                              child: const Text('See details'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}