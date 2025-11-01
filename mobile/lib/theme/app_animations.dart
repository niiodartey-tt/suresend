import 'package:flutter/material.dart';

/// Unified Animation System for SureSend
/// Provides consistent animations, transitions, and helper widgets
class AppAnimations {
  AppAnimations._();

  // ============================================
  // ANIMATION DURATIONS
  // ============================================
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration standard = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 1000);

  // Legacy aliases
  static const Duration fastDuration = fast;
  static const Duration standardDuration = standard;
  static const Duration slowDuration = slow;

  // ============================================
  // ANIMATION CURVES
  // ============================================
  static const Curve standardCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.easeOutBack;
  static const Curve smoothCurve = Curves.easeInOutCubic;
  static const Curve sharpCurve = Curves.easeOut;

  // ============================================
  // PAGE ROUTE TRANSITIONS
  // ============================================

  /// Slide page transition from right
  static PageRouteBuilder slideRight({required Widget page, Duration? duration}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? standard,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: standardCurve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  /// Slide page transition from left
  static PageRouteBuilder slideLeft({required Widget page, Duration? duration}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? standard,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: standardCurve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  /// Slide page transition from bottom
  static PageRouteBuilder slideUp({required Widget page, Duration? duration}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? standard,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: sharpCurve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  /// Slide page transition from top
  static PageRouteBuilder slideDown({required Widget page, Duration? duration}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? standard,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, -1.0);
        const end = Offset.zero;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: sharpCurve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  /// Generic slide page route with customizable direction
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
      transitionDuration: duration ?? standard,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = getBeginOffset();
        var end = Offset.zero;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: standardCurve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  /// Fade page transition
  static PageRouteBuilder fadePageRoute({
    required Widget page,
    Duration? duration,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? standard,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  /// Scale page transition with fade
  static PageRouteBuilder scalePageRoute({
    required Widget page,
    Duration? duration,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? standard,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(begin: 0.8, end: 1.0).chain(CurveTween(curve: standardCurve));
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

  // ============================================
  // ANIMATION BUILDERS
  // ============================================

  /// Staggered list item animation
  static Animation<double> staggeredListItem(
    AnimationController controller,
    int index, {
    double startInterval = 0.0,
    double itemSlideInterval = 0.05,
  }) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          startInterval + (index * itemSlideInterval),
          startInterval + (index * itemSlideInterval) + 0.5,
          curve: sharpCurve,
        ),
      ),
    );
  }

  /// Scale animation builder
  static Animation<double> scale(AnimationController controller) {
    return Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: sharpCurve,
      ),
    );
  }

  /// Fade animation builder
  static Animation<double> fade(AnimationController controller) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ),
    );
  }

  // ============================================
  // WIDGET WRAPPERS
  // ============================================

  /// Fade in animation wrapper
  static Widget fadeIn({
    required Widget child,
    Duration? duration,
    Duration? delay,
    Curve? curve,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration ?? standard,
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

  /// Slide in from bottom animation wrapper
  static Widget slideInFromBottom({
    required Widget child,
    Duration? duration,
    Curve? curve,
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: const Offset(0, 0.3), end: Offset.zero),
      duration: duration ?? standard,
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

  /// Scale in animation wrapper
  static Widget scaleIn({
    required Widget child,
    Duration? duration,
    Curve? curve,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: duration ?? standard,
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
}

// ============================================
// HELPER WIDGETS
// ============================================

/// Animated list item that fades and slides in with stagger effect
class AnimatedListItem extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration? duration;
  final Duration? delay;

  const AnimatedListItem({
    super.key,
    required this.child,
    required this.index,
    this.duration,
    this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final itemDelay = delay ?? Duration(milliseconds: 50 * index);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: (duration ?? AppAnimations.standard) + itemDelay,
      curve: AppAnimations.standardCurve,
      builder: (context, value, child) {
        final adjustedValue =
            (value * (1 + (itemDelay.inMilliseconds / 300))).clamp(0.0, 1.0);

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
    super.key,
    required this.child,
    required this.onPressed,
    this.duration,
  });

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
      duration: widget.duration ?? AppAnimations.fast,
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
    super.key,
    required this.child,
    this.duration,
    this.minScale = 0.95,
    this.maxScale = 1.05,
  });

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
      duration: widget.duration ?? AppAnimations.verySlow,
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

/// Shimmer effect for loading states
class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration? duration;

  const ShimmerEffect({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration,
  });

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

// ============================================
// BACKWARDS COMPATIBILITY
// ============================================

/// Legacy AnimationHelpers class for backwards compatibility
@Deprecated('Use AppAnimations instead')
class AnimationHelpers {
  AnimationHelpers._();

  static const Duration standardDuration = AppAnimations.standard;
  static const Duration slowDuration = AppAnimations.slow;
  static const Duration fastDuration = AppAnimations.fast;

  static const Curve standardCurve = AppAnimations.standardCurve;
  static const Curve bounceCurve = AppAnimations.bounceCurve;
  static const Curve smoothCurve = AppAnimations.smoothCurve;

  static Widget fadeIn({
    required Widget child,
    Duration? duration,
    Duration? delay,
    Curve? curve,
  }) =>
      AppAnimations.fadeIn(
        child: child,
        duration: duration,
        delay: delay,
        curve: curve,
      );

  static Widget slideInFromBottom({
    required Widget child,
    Duration? duration,
    Curve? curve,
  }) =>
      AppAnimations.slideInFromBottom(
        child: child,
        duration: duration,
        curve: curve,
      );

  static Widget scaleIn({
    required Widget child,
    Duration? duration,
    Curve? curve,
  }) =>
      AppAnimations.scaleIn(
        child: child,
        duration: duration,
        curve: curve,
      );

  static PageRouteBuilder slidePageRoute({
    required Widget page,
    AxisDirection direction = AxisDirection.left,
    Duration? duration,
  }) =>
      AppAnimations.slidePageRoute(
        page: page,
        direction: direction,
        duration: duration,
      );

  static PageRouteBuilder fadePageRoute({
    required Widget page,
    Duration? duration,
  }) =>
      AppAnimations.fadePageRoute(
        page: page,
        duration: duration,
      );

  static PageRouteBuilder scalePageRoute({
    required Widget page,
    Duration? duration,
  }) =>
      AppAnimations.scalePageRoute(
        page: page,
        duration: duration,
      );
}
