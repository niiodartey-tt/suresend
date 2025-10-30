import 'package:flutter/material.dart';
import 'package:suresend/theme/app_theme.dart';

class TransactionTypeModal extends StatelessWidget {
  const TransactionTypeModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusXl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(AppTheme.radiusS),
            ),
          ),
          SizedBox(height: AppTheme.spacingL),
          Text(
            'Transaction Type',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: AppTheme.spacingXl),
          _TransactionTypeCard(
            title: 'Product Based',
            subtitle: 'I want to sell a product',
            icon: Icons.inventory_2_rounded,
            onTap: () {
              Navigator.pop(context, 'product');
              // Navigate to create transaction
            },
          ),
          SizedBox(height: AppTheme.spacingM),
          _TransactionTypeCard(
            title: 'Service Based',
            subtitle: 'I want to provide a service',
            icon: Icons.handshake_rounded,
            onTap: () {
              Navigator.pop(context, 'service');
              // Navigate to create transaction
            },
          ),
          SizedBox(height: AppTheme.spacingL),
        ],
      ),
    );
  }
}

class _TransactionTypeCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _TransactionTypeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_TransactionTypeCard> createState() => _TransactionTypeCardState();
}

class _TransactionTypeCardState extends State<_TransactionTypeCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: Border.all(
            color: _isPressed ? AppTheme.primary : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                child: Icon(
                  widget.icon,
                  color: AppTheme.primary,
                  size: 32,
                ),
              ),
              SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: AppTheme.spacingXs),
                    Text(
                      widget.subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppTheme.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
