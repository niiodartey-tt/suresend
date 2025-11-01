import 'package:flutter/material.dart';
import 'package:suresend/theme/app_colors.dart';
import 'package:suresend/widgets/success_screen.dart';
import 'package:suresend/screens/home/home_screen.dart';

/// Transaction Successful Screen
/// Matches specification: transaction_successful.png
class TransactionSuccessfulScreen extends StatelessWidget {
  final String? transactionId;
  final String amount;
  final String date;

  const TransactionSuccessfulScreen({
    super.key,
    this.transactionId,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      title: 'Transaction Successful',
      description: 'Your transaction has been completed successfully.',
      transactionId: transactionId ?? 'ESC-10234',
      amount: amount,
      status: 'Completed',
      statusColor: AppColors.success,
      date: date,
      onBackToDashboard: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      },
      onDownload: () {
        // TODO: Implement download receipt functionality
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Downloading receipt...')),
        );
      },
      onShare: () {
        // TODO: Implement share functionality
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Share transaction...')),
        );
      },
    );
  }
}
