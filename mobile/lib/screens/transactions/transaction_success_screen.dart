import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../dashboard/unified_dashboard.dart';

class TransactionSuccessScreen extends StatelessWidget {
  final String title;
  final String message;
  final String? amount;
  final String? reference;
  final Map<String, String>? details;

  const TransactionSuccessScreen({
    Key? key,
    required this.title,
    required this.message,
    this.amount,
    this.reference,
    this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.green.shade600,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 16),

              // Message
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 32),

              // Details Card
              if (amount != null || reference != null || details != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      if (amount != null) ...[
                        _DetailRow(
                          label: 'Amount',
                          value: amount!,
                          valueBold: true,
                          valueColor: AppTheme.primaryColor,
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (reference != null) ...[
                        _DetailRow(
                          label: 'Reference',
                          value: reference!,
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (details != null)
                        ...details!.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _DetailRow(
                              label: entry.key,
                              value: entry.value,
                            ),
                          );
                        }).toList(),
                    ],
                  ),
                ),
              const SizedBox(height: 48),

              // Go to Dashboard Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to dashboard and remove all previous routes
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const UnifiedDashboard(),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.buttonBorderRadius),
                  ),
                ),
                child: const Text(
                  'Go to Dashboard',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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

  const _DetailRow({
    Key? key,
    required this.label,
    required this.value,
    this.valueBold = false,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              fontWeight: valueBold ? FontWeight.bold : FontWeight.w600,
              color: valueColor ?? AppTheme.textPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
