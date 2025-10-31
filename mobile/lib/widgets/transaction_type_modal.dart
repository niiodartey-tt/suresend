import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/theme.dart';

/// Transaction Type Selection Modal
/// Matches ui_references/create_transaction(+ button).png
class TransactionTypeModal extends StatelessWidget {
  final Function(String) onSelect;

  const TransactionTypeModal({
    super.key,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Create Transaction',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: AppColors.textMuted,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Choose whether you want to buy or sell',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 24),

            // Buy Option
            _buildOption(
              context,
              icon: Icons.shopping_cart_outlined,
              iconColor: AppColors.primary,
              backgroundColor: AppColors.accentBackground,
              title: 'Buy',
              subtitle: 'I want to purchase something',
              onTap: () {
                Navigator.of(context).pop();
                onSelect('buy');
              },
            ),
            const SizedBox(height: 16),

            // Sell Option
            _buildOption(
              context,
              icon: Icons.storefront_outlined,
              iconColor: AppColors.success,
              backgroundColor: AppColors.successLight,
              title: 'Sell',
              subtitle: 'I want to sell a product or service',
              isSelected: false,
              onTap: () {
                Navigator.of(context).pop();
                onSelect('sell');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(
            color: isSelected
                ? iconColor
                : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper function to show the transaction type modal
Future<String?> showTransactionTypeModal(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => TransactionTypeModal(
      onSelect: (type) {
        // Type will be 'buy' or 'sell'
      },
    ),
  );
}
