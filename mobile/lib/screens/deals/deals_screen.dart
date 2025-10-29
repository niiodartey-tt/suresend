import 'package:flutter/material.dart';
import 'package:suresend/theme/app_theme.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  _DealsScreenState createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller; // Make controller final

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green.shade700;
      case 'In Escrow':
        return AppTheme.primary;
      case 'In Progress':
        return Colors.orange.shade700;
      case 'Pending':
        return Colors.grey.shade700;
      default:
        return Colors.grey;
    }
  }

  // Add proper dispose
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> deals = [
      {
        'id': 'ESC-10234',
        'title': 'iPhone 15 Pro',
        'type': 'product',
        'amount': 450,
        'status': 'In Escrow',
        'counterparty': 'Alice Smith',
        'role': 'seller',
        'date': 'Oct 24, 2025',
      },
      {
        'id': 'ESC-10233',
        'title': 'MacBook Pro',
        'type': 'product',
        'amount': 1200,
        'status': 'Completed',
        'counterparty': 'Bob Johnson',
        'role': 'buyer',
        'date': 'Oct 22, 2025',
      },
      {
        'id': 'ESC-10232',
        'title': 'Web Design Service',
        'type': 'service',
        'amount': 350,
        'status': 'In Progress',
        'counterparty': 'Carol White',
        'role': 'seller',
        'date': 'Oct 20, 2025',
      },
      {
        'id': 'ESC-10231',
        'title': 'Logo Design',
        'type': 'service',
        'amount': 200,
        'status': 'Pending',
        'counterparty': 'David Brown',
        'role': 'buyer',
        'date': 'Oct 18, 2025',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Deals'),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        itemCount: deals.length,
        itemBuilder: (context, index) {
          final deal = deals[index];
          final roleIsBuyer = deal['role'] == 'buyer';

          return Card(
            margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
            ),
            elevation: 2,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/transaction-details',
                    arguments: deal);
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
                                ? AppTheme.withAlpha(AppTheme.primary, 0.08)
                                : AppTheme.withAlpha(Colors.green, 0.08),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusM),
                          ),
                          child: Icon(
                            deal['type'] == 'product'
                                ? Icons.inventory_2_rounded
                                : Icons.handshake_rounded,
                            color:
                                roleIsBuyer ? AppTheme.primary : Colors.green,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              deal['title'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: roleIsBuyer
                                                    ? AppTheme.primary
                                                        .withOpacity(0.08)
                                                    : Colors.green
                                                        .withOpacity(0.08),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                roleIsBuyer
                                                    ? 'Buying'
                                                    : 'Selling',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: roleIsBuyer
                                                      ? AppTheme.primary
                                                      : Colors.green,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          deal['id'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${roleIsBuyer ? "-" : "+"}\$${deal['amount']}',
                                        style: TextStyle(
                                          color: roleIsBuyer
                                              ? Colors.red
                                              : Colors.green,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppTheme.spacingM),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(deal['status'])
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          deal['status'],
                                          style: TextStyle(
                                            color:
                                                _getStatusColor(deal['status']),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: AppTheme.spacingM),
                                      Text(
                                        deal['date'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${roleIsBuyer ? 'Seller' : 'Buyer'}: ${deal['counterparty']}",
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-transaction');
        },
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
