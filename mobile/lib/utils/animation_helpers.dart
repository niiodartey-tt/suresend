import 'package:flutter/material.dart';

/// Animation helper utilities for consistent animations across the app
class AnimationHelpers {
  AnimationHelpers._();

  /// Standard animation duration
  static const Duration standardDuration = Duration(milliseconds: 300);
  static const Duration slowDuration = Duration(milliseconds: 500);
  static const Duration fastDuration = Duration(milliseconds: 150);

  /// Standard animation curve
  static const Curve standardCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.easeOutBack;
  static const Curve smoothCurve = Curves.easeInOutCubic;

  /// Fade in animation
  static Widget fadeIn({
    required Widget child,
    Duration? duration,
    Duration? delay,
    Curve? curve,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration ?? standardDuration,
      curve: curve ?? standardCurve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// Slide in from bottom animation
  static Widget slideInFromBottom({
    required Widget child,
    Duration? duration,
    Curve? curve,
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: const Offset(0, 0.3), end: Offset.zero),
      duration: duration ?? standardDuration,
      curve: curve ?? standardCurve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: value * 100,
          child: Opacity(
            opacity: 1 - (value.dy / 0.3),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// Scale in animation
  static Widget scaleIn({
    required Widget child,
    Duration? duration,
    Curve? curve,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: duration ?? standardDuration,
      curve: curve ?? bounceCurve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// Page route with slide transition
  static PageRouteBuilder slidePageRoute({
    required Widget page,
    AxisDirection direction = AxisDirection.left,
    Duration? duration,
  }) {
    Offset getBeginOffset() {
      switch (direction) {
        case AxisDirection.left:
          return const Offset(1.0, 0.0);
        case AxisDirection.right:
          return const Offset(-1.0, 0.0);
        case AxisDirection.up:
          return const Offset(0.0, 1.0);
        case AxisDirection.down:
          return const Offset(0.0, -1.0);
      }
    }

    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? standardDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = getBeginOffset();
        var end = Offset.zero;
        var curve = standardCurve;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  /// Page route with fade transition
  static PageRouteBuilder fadePageRoute({
    required Widget page,
    Duration? duration,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? standardDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  /// Page route with scale transition
  static PageRouteBuilder scalePageRoute({
    required Widget page,
    Duration? duration,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? standardDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var curve = standardCurve;
        var tween = Tween(begin: 0.8, end: 1.0).chain(CurveTween(curve: curve));
        var scaleAnimation = animation.drive(tween);

        return ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }
}

/// Animated list item that fades and slides in
class AnimatedListItem extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration? duration;
  final Duration? delay;

  const AnimatedListItem({
    Key? key,
    required this.child,
    required this.index,
    this.duration,
    this.delay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemDelay = delay ?? Duration(milliseconds: 50 * index);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: (duration ?? AnimationHelpers.standardDuration) + itemDelay,
      curve: AnimationHelpers.standardCurve,
      builder: (context, value, child) {
        final adjustedValue = (value * (1 + (itemDelay.inMilliseconds / 300)))
            .clamp(0.0, 1.0);

        return Transform.translate(
          offset: Offset(0, 20 * (1 - adjustedValue)),
          child: Opacity(
            opacity: adjustedValue,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// Animated button with scale effect on tap
class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Duration? duration;

  const AnimatedButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.duration,
  }) : super(key: key);

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? AnimationHelpers.fastDuration,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null ? _handleTapDown : null,
      onTapUp: widget.onPressed != null ? _handleTapUp : null,
      onTapCancel: widget.onPressed != null ? _handleTapCancel : null,
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Pulse animation widget for attention-grabbing elements
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration? duration;
  final double minScale;
  final double maxScale;

  const PulseAnimation({
    Key? key,
    required this.child,
    this.duration,
    this.minScale = 0.95,
    this.maxScale = 1.05,
  }) : super(key: key);

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

/// Shimmer effect for loading states (alternative to skeleton)
class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration? duration;

  const ShimmerEffect({
    Key? key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration,
  }) : super(key: key);

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.baseColor ?? Colors.grey[300]!,
                widget.highlightColor ?? Colors.grey[100]!,
                widget.baseColor ?? Colors.grey[300]!,
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
