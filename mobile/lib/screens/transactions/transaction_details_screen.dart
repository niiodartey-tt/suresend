import 'package:flutter/material.dart';
import 'package:suresend/theme/app_theme.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetailsScreen({
    super.key, // Add super.key
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transaction Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          transaction['id'],
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        _StatusChip(status: transaction['status']),
                      ],
                    ),
                    SizedBox(height: AppTheme.spacingM),
                    Text(
                      '\$${transaction['amount'].toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: AppTheme.spacingL),

            // Buyer/Seller Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  children: [
                    _UserInfoTile(
                      title: 'Seller',
                      name: transaction['seller']['name'],
                      avatar: transaction['seller']['avatar'],
                      phone: transaction['seller']['phone'],
                    ),
                    Divider(height: AppTheme.spacingL),
                    _UserInfoTile(
                      title: 'Buyer',
                      name: transaction['buyer']['name'],
                      avatar: transaction['buyer']['avatar'],
                      phone: transaction['buyer']['phone'],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: AppTheme.spacingL),

            // Progress Tracker
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: AppTheme.spacingM),
                    const _ProgressTracker(currentStep: 2),
                  ],
                ),
              ),
            ),

            SizedBox(height: AppTheme.spacingL),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle release funds
                    },
                    child: const Text('Release Funds'),
                  ),
                ),
                SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Handle raise dispute
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('Raise Dispute'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to chat
        },
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.chat_rounded),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'completed':
        color = Colors.green;
        break;
      case 'disputed':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingXs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _UserInfoTile extends StatelessWidget {
  final String title;
  final String name;
  final String avatar;
  final String phone;

  const _UserInfoTile({
    required this.title,
    required this.name,
    required this.avatar,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(avatar),
        ),
        SizedBox(width: AppTheme.spacingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: AppTheme.spacingXs),
              Text(
                name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: AppTheme.spacingXs),
              Text(
                phone,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgressTracker extends StatelessWidget {
  final int currentStep;

  const _ProgressTracker({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    const steps = [
      'Initiated',
      'In Escrow',
      'Delivered',
      'Completed',
    ];

    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          return Expanded(
            child: Container(
              height: 2,
              color:
                  index < currentStep * 2 ? AppTheme.primary : Colors.grey[300],
            ),
          );
        }

        final stepIndex = index ~/ 2;
        final isCompleted = stepIndex <= currentStep;
        final isActive = stepIndex == currentStep;

        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isCompleted ? AppTheme.primary : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: isActive
              ? const Center(
                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                )
              : null,
        );
      }),
    );
  }
}
