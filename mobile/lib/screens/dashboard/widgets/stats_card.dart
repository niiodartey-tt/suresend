import 'package:flutter/material.dart';
import 'package:suresend/theme/app_theme.dart';

class StatsCard extends StatefulWidget {
  final int index;

  const StatsCard({super.key, required this.index});

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.1 * widget.index,
          0.1 * widget.index + 0.5,
          curve: Curves.easeOut,
        ),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getTitle() {
    switch (widget.index) {
      case 0:
        return 'Active';
      case 1:
        return 'Completed';
      case 2:
        return 'Disputes';
      case 3:
        return 'Total';
      default:
        return '';
    }
  }

  String _getValue() {
    switch (widget.index) {
      case 0:
        return '12';
      case 1:
        return '45';
      case 2:
        return '2';
      case 3:
        return '59';
      default:
        return '0';
    }
  }

  IconData _getIcon() {
    switch (widget.index) {
      case 0:
        return Icons.pending_actions_rounded;
      case 1:
        return Icons.check_circle_rounded;
      case 2:
        return Icons.error_rounded;
      case 3:
        return Icons.analytics_rounded;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _getIcon(),
                color: AppTheme.primary,
                size: 24,
              ),
              const Spacer(),
              Text(
                _getValue(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: AppTheme.spacingXs),
              Text(
                _getTitle(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
