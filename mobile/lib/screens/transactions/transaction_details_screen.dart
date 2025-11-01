import 'package:flutter/material.dart';
import 'package:suresend/config/app_colors.dart';
import 'package:suresend/config/theme.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final String transactionId;

  const TransactionDetailsScreen({
    super.key,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context) {
    // Mock data - in real app, fetch from API using transactionId
    final transaction = {
      'id': transactionId,
      'status': 'In Escrow',
      'description': 'MacBook Pro M3',
      'fullDescription': 'Brand new MacBook Pro 14-inch with M3 chip',
      'amount': 850.00,
      'created': 'Oct 28, 2025',
      'progress': 50,
      'currentStep': 1, // 0: Initiated, 1: In Escrow, 2: Delivered, 3: Completed
      'seller': {'name': 'Sarah Johnson', 'role': 'Seller'},
      'buyer': {'name': 'John Doe', 'role': 'Buyer'},
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.primaryForeground,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Transaction Details', style: TextStyle(fontSize: 18)),
            Text(
              transaction['id'],
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Transaction Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            transaction['description'],
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          _buildStatusBadge(transaction['status']),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        transaction['fullDescription'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Amount',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textMuted,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${transaction['amount'].toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Created',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textMuted,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                transaction['created'],
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Transaction Progress Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Transaction Progress',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            '${transaction['progress']}%',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppTheme.radiusXs),
                        child: LinearProgressIndicator(
                          value: transaction['progress'] / 100,
                          minHeight: 8,
                          backgroundColor: AppColors.background,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Progress Steps
                      _buildProgressStep(
                        context,
                        icon: Icons.play_circle_outline,
                        title: 'Initiated',
                        time: 'Oct 24, 2025 10:30 AM',
                        isCompleted: transaction['currentStep'] >= 0,
                        isActive: transaction['currentStep'] == 0,
                      ),
                      _buildProgressStep(
                        context,
                        icon: Icons.lock_outline,
                        title: 'In Escrow',
                        time: 'Oct 24, 2025 10:35 AM',
                        isCompleted: transaction['currentStep'] >= 1,
                        isActive: transaction['currentStep'] == 1,
                      ),
                      _buildProgressStep(
                        context,
                        icon: Icons.local_shipping_outlined,
                        title: 'Delivered',
                        time: '',
                        isCompleted: transaction['currentStep'] >= 2,
                        isActive: transaction['currentStep'] == 2,
                      ),
                      _buildProgressStep(
                        context,
                        icon: Icons.check_circle_outline,
                        title: 'Completed',
                        time: '',
                        isCompleted: transaction['currentStep'] >= 3,
                        isActive: transaction['currentStep'] == 3,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Participants Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Participants',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 16),
                      _buildParticipant(
                        context,
                        name: transaction['seller']['name'],
                        role: transaction['seller']['role'],
                        avatarColor: const Color(0xFF3B82F6),
                      ),
                      const SizedBox(height: 12),
                      _buildParticipant(
                        context,
                        name: transaction['buyer']['name'],
                        role: transaction['buyer']['role'],
                        avatarColor: const Color(0xFF10B981),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 80), // Space for bottom nav if needed
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    Color bgColor;

    switch (status) {
      case 'In Escrow':
        color = AppColors.primary;
        bgColor = AppColors.primary.withValues(alpha: 0.1);
        break;
      case 'Completed':
        color = AppColors.success;
        bgColor = AppColors.successLight;
        break;
      case 'In Progress':
        color = const Color(0xFFF59E0B);
        bgColor = const Color(0xFFFEF3C7);
        break;
      case 'Disputed':
        color = AppColors.error;
        bgColor = AppColors.errorLight;
        break;
      default:
        color = AppColors.textMuted;
        bgColor = AppColors.background;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppTheme.modalBorderRadius),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildProgressStep(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String time,
    required bool isCompleted,
    required bool isActive,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.success
                    : isActive
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : AppColors.background,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted || isActive
                      ? isCompleted
                          ? AppColors.success
                          : AppColors.primary
                      : AppColors.border,
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                size: 16,
                color: isCompleted
                    ? AppColors.primaryForeground
                    : isActive
                        ? AppColors.primary
                        : AppColors.textMuted,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? AppColors.success : AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: isCompleted || isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isCompleted || isActive
                            ? AppColors.textPrimary
                            : AppColors.textMuted,
                      ),
                ),
                if (time.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildParticipant(
    BuildContext context, {
    required String name,
    required String role,
    required Color avatarColor,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: avatarColor.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              name[0].toUpperCase(),
              style: TextStyle(
                color: avatarColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                role,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
