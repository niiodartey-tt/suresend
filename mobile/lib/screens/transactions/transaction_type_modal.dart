import 'package:flutter/material.dart';
import 'package:suresend/theme/app_colors.dart';
import 'package:suresend/theme/app_theme.dart';
import 'create_transaction_screen.dart';

class TransactionTypeModal extends StatelessWidget {
  const TransactionTypeModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
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
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                iconSize: 20,
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
          _TransactionTypeOption(
            icon: Icons.shopping_cart_outlined,
            iconColor: const Color(0xFF3B82F6),
            iconBgColor: const Color(0xFFDBeafe),
            title: 'Buy',
            subtitle: 'I want to purchase something',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateTransactionScreen(
                    transactionType: 'buy',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Sell Option
          _TransactionTypeOption(
            icon: Icons.store_outlined,
            iconColor: const Color(0xFF10B981),
            iconBgColor: const Color(0xFFD1FAE5),
            title: 'Sell',
            subtitle: 'I want to sell a product or service',
            isHighlighted: true,
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateTransactionScreen(
                    transactionType: 'sell',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _TransactionTypeOption extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final bool isHighlighted;
  final VoidCallback onTap;

  const _TransactionTypeOption({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    this.isHighlighted = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isHighlighted
              ? const Color(0xFFD1FAE5)
              : AppColors.background,
          borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
          border: Border.all(
            color: isHighlighted
                ? const Color(0xFF10B981)
                : AppColors.border,
            width: isHighlighted ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 24),
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
