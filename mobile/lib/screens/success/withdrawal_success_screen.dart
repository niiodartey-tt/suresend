import 'package:flutter/material.dart';
import 'package:suresend/theme/app_colors.dart';
import 'package:suresend/widgets/success_screen.dart';
import 'package:suresend/screens/home/home_screen.dart';

/// Withdrawal Successful Screen
/// Matches specification: withdrawal_success.png
class WithdrawalSuccessScreen extends StatelessWidget {
  final String transactionId;
  final String amount;
  final String date;

  const WithdrawalSuccessScreen({
    super.key,
    required this.transactionId,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      title: 'Withdrawal Successful',
      description: 'Your withdrawal request has been processed successfully.',
      transactionId: transactionId,
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Downloading receipt...')),
        );
      },
      onShare: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Share transaction...')),
        );
      },
    );
  }
}
