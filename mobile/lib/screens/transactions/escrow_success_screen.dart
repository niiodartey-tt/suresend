import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:suresend/theme/app_colors.dart';
import 'package:suresend/theme/app_theme.dart';
import '../navigation/main_navigation.dart';

/// Escrow Success Screen matching ui_reference/create_escrow_success.png
class EscrowSuccessScreen extends StatelessWidget {
  final String transactionId;
  final String amount;
  final String status;
  final DateTime date;
  final String? title;
  final String? message;

  const EscrowSuccessScreen({
    super.key,
    required this.transactionId,
    required this.amount,
    required this.status,
    required this.date,
    this.title,
    this.message,
  });

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final month = months[date.month - 1];
    final day = date.day;
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$month $day, $year, $hour:$minute ${date.hour >= 12 ? 'PM' : 'AM'}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),

                      // Success Icon
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer circle ring
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primaryForeground.withValues(alpha: 0.3),
                                  width: 3,
                                ),
                              ),
                            ),
                            // Checkmark
                            const Icon(
                              Icons.check,
                              size: 50,
                              color: AppColors.primaryForeground,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Title
                      Text(
                        title ?? 'Escrow Created Successfully',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Message
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          message ??
                              'Your escrow transaction has been created successfully. Funds are now held securely until delivery confirmation.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textMuted,
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Details Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _DetailRow(
                              label: 'Transaction ID',
                              value: transactionId,
                              valueBold: false,
                            ),
                            const SizedBox(height: 16),
                            _DetailRow(
                              label: 'Amount',
                              value: amount.startsWith('GHS') || amount.startsWith('₵')
                                  ? amount
                                  : 'GHS $amount',
                              valueBold: true,
                              valueColor: AppColors.textPrimary,
                            ),
                            const SizedBox(height: 16),
                            _DetailRow(
                              label: 'Status',
                              value: status,
                              valueWidget: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.statusEscrowBg,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  status,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.statusEscrowText,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _DetailRow(
                              label: 'Date',
                              value: _formatDate(date),
                              valueBold: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Action Buttons
              Column(
                children: [
                  // View Transaction Details Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to transaction details
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const MainNavigation(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.primaryForeground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'View Transaction Details',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Download and Share Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Download receipt functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Receipt downloaded'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.download_outlined, size: 20),
                          label: const Text(
                            'Download',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: const BorderSide(color: AppColors.border),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Share functionality
                            Share.share(
                              'Transaction ID: $transactionId\nAmount: $amount\nStatus: $status',
                              subject: 'Escrow Transaction',
                            );
                          },
                          icon: const Icon(Icons.share_outlined, size: 20),
                          label: const Text(
                            'Share',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: const BorderSide(color: AppColors.border),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
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
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool valueBold;
  final Color? valueColor;
  final Widget? valueWidget;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueBold = false,
    this.valueColor,
    this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(width: 16),
        valueWidget ??
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: valueBold ? FontWeight.w700 : FontWeight.w500,
                  color: valueColor ?? AppColors.textPrimary,
                ),
                textAlign: TextAlign.right,
              ),
            ),
      ],
    );
  }
}
