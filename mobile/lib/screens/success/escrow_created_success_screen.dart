import 'package:flutter/material.dart';
import 'package:suresend/theme/app_colors.dart';
import 'package:suresend/widgets/success_screen.dart';
import 'package:suresend/screens/home/home_screen.dart';

/// Escrow Created Successfully Screen
/// Matches specification: create_escrow_success.png
class EscrowCreatedSuccessScreen extends StatelessWidget {
  final String transactionId;
  final String amount;
  final String date;

  const EscrowCreatedSuccessScreen({
    super.key,
    required this.transactionId,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      title: 'Escrow Created Successfully',
      description:
          'Your escrow transaction has been created successfully. Funds are now held securely until delivery confirmation.',
      transactionId: transactionId,
      amount: amount,
      status: 'In Escrow',
      statusColor: AppColors.primary,
      date: date,
      onBackToDashboard: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      },
      onViewDetails: () {
        // TODO: Navigate to transaction details
        Navigator.pop(context);
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
      toastMessage: 'Notifications sent to both parties',
    );
  }
}
