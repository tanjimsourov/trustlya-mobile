import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../core/theme/app_curves.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_typography.dart';

/// Animates a number counting up from zero to the target value. Useful
/// for stats and balances. Accepts a formatting callback for custom
/// string representations.
class NumberCountUp extends StatelessWidget {
  final double target;
  final Duration duration;
  final Curve curve;
  final String Function(double)? formatter;
  const NumberCountUp(
      {Key? key,
      required this.target,
      this.duration = AppDurations.medium,
      this.curve = AppCurves.deceleration,
      this.formatter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: target),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        final display =
            formatter != null ? formatter!(value) : value.toStringAsFixed(0);
        return Text(display, style: AppTypography.h2);
      },
    );
  }
}

/// Animates a balance value that can toggle between blurred and revealed
/// states. Useful when hiding sensitive information.
class BalanceReveal extends StatefulWidget {
  final String value;
  const BalanceReveal({Key? key, required this.value}) : super(key: key);

  @override
  _BalanceRevealState createState() => _BalanceRevealState();
}

class _BalanceRevealState extends State<BalanceReveal> {
  bool _revealed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _revealed = !_revealed),
      child: AnimatedCrossFade(
        firstChild: Container(
          width: 100,
          height: 24,
          color: Colors.grey.shade300,
        ),
        secondChild: Text(widget.value, style: AppTypography.h2),
        crossFadeState:
            _revealed ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: AppDurations.medium,
      ),
    );
  }
}

/// A shimmer effect used to indicate loading content. It animates a
/// sweeping gradient across a placeholder box. You can wrap any widget
/// inside to apply the effect.
class ShimmerLoading extends StatefulWidget {
  final Widget child;
  const ShimmerLoading({Key? key, required this.child}) : super(key: key);

  @override
  _ShimmerLoadingState createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
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
          shaderCallback: (rect) {
            return LinearGradient(
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300
              ],
              stops: const [0.25, 0.5, 0.75],
              begin: Alignment(-1 + 2 * _controller.value, -0.3),
              end: Alignment(1 + 2 * _controller.value, 0.3),
            ).createShader(rect);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}

/// Provides a hover scale animation for cards or interactive elements on
/// desktop platforms. On hover the child slightly increases in size.
class CardHoverAnimation extends StatefulWidget {
  final Widget child;
  const CardHoverAnimation({Key? key, required this.child}) : super(key: key);

  @override
  _CardHoverAnimationState createState() => _CardHoverAnimationState();
}

class _CardHoverAnimationState extends State<CardHoverAnimation> {
  bool _hovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.02 : 1.0,
        duration: AppDurations.short,
        curve: AppCurves.standard,
        child: widget.child,
      ),
    );
  }
}

/// Reveals children in a staggered fashion. Accepts a list of children and
/// animates them in sequence when this widget appears in the tree.
class StaggerReveal extends StatefulWidget {
  final List<Widget> children;
  final Duration duration;
  const StaggerReveal(
      {Key? key, required this.children, this.duration = AppDurations.long})
      : super(key: key);

  @override
  _StaggerRevealState createState() => _StaggerRevealState();
}

class _StaggerRevealState extends State<StaggerReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<double>> _animations;
  @override
  void initState() {
    super.initState();
    final count = widget.children.length;
    _controller = AnimationController(vsync: this, duration: widget.duration);
    final interval = 1.0 / math.max(1, count);
    _animations = List.generate(count, (i) {
      final start = i * interval;
      final end = start + interval;
      return CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: AppCurves.deceleration));
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.children.length, (i) {
        return FadeTransition(
          opacity: _animations[i],
          child: SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
                    .animate(_animations[i]),
            child: widget.children[i],
          ),
        );
      }),
    );
  }
}

/// A wrapper that animates its child sliding up and fading in. Use for
/// call‑to‑action buttons entering the viewport.
class CTAEntranceAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  const CTAEntranceAnimation(
      {Key? key, required this.child, this.duration = AppDurations.medium})
      : super(key: key);

  @override
  _CTAEntranceAnimationState createState() => _CTAEntranceAnimationState();
}

class _CTAEntranceAnimationState extends State<CTAEntranceAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation =
        CurvedAnimation(parent: _controller, curve: AppCurves.deceleration);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
            .animate(_animation),
        child: widget.child,
      ),
    );
  }
}
