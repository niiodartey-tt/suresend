import 'package:flutter/material.dart';
import 'package:suresend/theme/app_colors.dart';
import 'package:suresend/theme/app_theme.dart';

/// Withdrawal Success Screen
/// Matches ui_references/withdrawal_success.png
class WithdrawalSuccessScreen extends StatelessWidget {
  final double amount;
  final String method;
  final String accountNumber;
  final String transactionId;
  final String date;

  const WithdrawalSuccessScreen({
    super.key,
    this.amount = 500.00,
    this.method = 'Bank Transfer',
    this.accountNumber = '****4567',
    this.transactionId = 'WD-98234',
    this.date = 'Oct 30, 2025, 2:45 PM',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Withdrawal'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.primaryForeground,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Success Icon
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.success.withValues(alpha: 0.2),
                                blurRadius: 16,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            size: 64,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing32),

                        // Title
                        Text(
                          'Withdrawal Successful',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppTheme.spacing12),

                        // Subtitle
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacing24),
                          child: Text(
                            'Your withdrawal request has been processed successfully. Funds will be transferred to your account shortly.',
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing32),

                        // Amount Display
                        Container(
                          padding: const EdgeInsets.all(AppTheme.spacing24),
                          decoration: BoxDecoration(
                            color: AppColors.accentBackground,
                            borderRadius: BorderRadius.circular(
                                AppTheme.cardBorderRadius),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Amount Withdrawn',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$${amount.toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing24),

                        // Details Card
                        Card(
                          elevation: AppTheme.elevationSm,
                          child: Padding(
                            padding: const EdgeInsets.all(AppTheme.spacing24),
                            child: Column(
                              children: [
                                _buildDetailRow(
                                  context,
                                  'Transaction ID',
                                  transactionId,
                                ),
                                const Divider(height: 24),
                                _buildDetailRow(
                                  context,
                                  'Withdrawal Method',
                                  method,
                                ),
                                const Divider(height: 24),
                                _buildDetailRow(
                                  context,
                                  'Account Number',
                                  accountNumber,
                                ),
                                const Divider(height: 24),
                                _buildDetailRow(
                                  context,
                                  'Date & Time',
                                  date,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Action Buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: const Text('Back to Dashboard'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Handle download receipt
                          },
                          icon: const Icon(Icons.download, size: 18),
                          label: const Text('Download Receipt'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Handle share
                          },
                          icon: const Icon(Icons.share, size: 18),
                          label: const Text('Share'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
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
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
