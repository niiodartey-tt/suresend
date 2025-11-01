import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Skeleton loader widget with shimmer effect for loading states
class SkeletonLoader extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;

  const SkeletonLoader({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
    this.margin,
  });

  const SkeletonLoader.rectangular({
    super.key,
    this.width,
    this.height = 16,
    this.margin,
  }) : borderRadius = const BorderRadius.all(Radius.circular(4));

  const SkeletonLoader.circular({
    super.key,
    required double size,
    this.margin,
  })  : width = size,
        height = size,
        borderRadius = null;

  const SkeletonLoader.card({
    super.key,
    this.width = double.infinity,
    this.height = 100,
    this.margin,
  }) : borderRadius = const BorderRadius.all(Radius.circular(20));

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isCircular = widget.borderRadius == null &&
        widget.width != null &&
        widget.width == widget.height;

    return Container(
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: isCircular
            ? BorderRadius.circular((widget.width ?? 0) / 2)
            : widget.borderRadius ?? BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.grey[300]!,
                  Colors.grey[100]!,
                  Colors.grey[300]!,
                ],
                stops: [
                  _animation.value - 0.3,
                  _animation.value,
                  _animation.value + 0.3,
                ],
              ),
              borderRadius: isCircular
                  ? BorderRadius.circular((widget.width ?? 0) / 2)
                  : widget.borderRadius ?? BorderRadius.circular(AppTheme.radiusMd),
            ),
          );
        },
      ),
    );
  }
}

/// Skeleton loader for list items
class SkeletonListTile extends StatelessWidget {
  final bool hasLeading;
  final bool hasSubtitle;
  final bool hasTrailing;
  final EdgeInsets? padding;

  const SkeletonListTile({
    super.key,
    this.hasLeading = true,
    this.hasSubtitle = true,
    this.hasTrailing = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (hasLeading) ...[
            const SkeletonLoader.circular(size: 40),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLoader(width: 120, height: 14),
                if (hasSubtitle) ...[
                  const SizedBox(height: 8),
                  const SkeletonLoader(width: 180, height: 12),
                ],
              ],
            ),
          ),
          if (hasTrailing) ...[
            const SizedBox(width: 12),
            const SkeletonLoader(width: 60, height: 14),
          ],
        ],
      ),
    );
  }
}

/// Skeleton loader for transaction cards
class SkeletonTransactionCard extends StatelessWidget {
  const SkeletonTransactionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            SkeletonLoader.circular(size: 48),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLoader(width: 140, height: 16),
                  SizedBox(height: 8),
                  SkeletonLoader(width: 100, height: 12),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SkeletonLoader(width: 80, height: 16),
                SizedBox(height: 8),
                SkeletonLoader(width: 60, height: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton loader for wallet balance card
class SkeletonWalletCard extends StatelessWidget {
  const SkeletonWalletCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
      ),
      child: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonLoader(width: 120, height: 14),
            SizedBox(height: 16),
            SkeletonLoader(width: 180, height: 32),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLoader(width: 100, height: 12),
                SkeletonLoader(width: 80, height: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton loader for notification items
class SkeletonNotificationCard extends StatelessWidget {
  const SkeletonNotificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonLoader.circular(size: 12),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLoader(width: double.infinity, height: 16),
                  SizedBox(height: 8),
                  SkeletonLoader(width: double.infinity, height: 14),
                  SizedBox(height: 8),
                  SkeletonLoader(width: 100, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
