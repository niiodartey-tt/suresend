import 'package:flutter/material.dart';
import 'package:suresend/theme/app_colors.dart';
import 'package:suresend/theme/app_theme.dart';

/// Escrow Created Success Screen
/// Matches ui_references/create_escrow_success.png
class EscrowCreatedSuccessScreen extends StatelessWidget {
  final String transactionId;
  final double amount;
  final String status;
  final String date;

  const EscrowCreatedSuccessScreen({
    super.key,
    this.transactionId = 'ESC-85205',
    this.amount = 355.00,
    this.status = 'In Escrow',
    this.date = 'Oct 30, 2025, 12:57 PM',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                          'Escrow Created Successfully',
                          style:
                              Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                            'Your escrow transaction has been created successfully. Funds are now held securely until delivery confirmation.',
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing32),

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
                                  'Amount',
                                  '\$${amount.toStringAsFixed(2)}',
                                  valueStyle: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const Divider(height: 24),
                                _buildDetailRow(
                                  context,
                                  'Status',
                                  status,
                                  valueWidget: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.statusEscrowBg,
                                      borderRadius: BorderRadius.circular(
                                        AppTheme.radiusSm,
                                      ),
                                    ),
                                    child: Text(
                                      status,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.statusEscrowText,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ),
                                const Divider(height: 24),
                                _buildDetailRow(
                                  context,
                                  'Date',
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
                        Navigator.of(context).pushNamed('/transaction-details',
                            arguments: {'transactionId': transactionId});
                      },
                      child: const Text('View Transaction Details'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Handle download
                          },
                          icon: const Icon(Icons.download, size: 18),
                          label: const Text('Download'),
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
    String? value, {
    TextStyle? valueStyle,
    Widget? valueWidget,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        valueWidget ??
            Text(
              value!,
              style: valueStyle ??
                  Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
            ),
      ],
    );
  }
}
