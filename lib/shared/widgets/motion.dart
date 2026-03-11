import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

class MotionReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final Offset beginOffset;
  final double beginScale;
  final double beginBlur;

  const MotionReveal({
    Key? key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 760),
    this.curve = Curves.easeOutCubic,
    this.beginOffset = const Offset(0, 0.028),
    this.beginScale = 0.988,
    this.beginBlur = 10,
  }) : super(key: key);

  @override
  State<MotionReveal> createState() => _MotionRevealState();
}

class _MotionRevealState extends State<MotionReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      _delayTimer = Timer(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (disableAnimations) {
      return widget.child;
    }

    final animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
      reverseCurve: Curves.easeInCubic,
    );

    return AnimatedBuilder(
      animation: animation,
      child: widget.child,
      builder: (context, child) {
        final t = animation.value;
        final slide = Offset.lerp(widget.beginOffset, Offset.zero, t)!;
        final scale = lerpDouble(widget.beginScale, 1, t)!;
        final blur = lerpDouble(widget.beginBlur, 0, t)!;

        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(slide.dx * 160, slide.dy * 160),
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.topCenter,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}

class MotionSwitcher extends StatelessWidget {
  final Widget child;
  final Object switchKey;
  final Duration duration;

  const MotionSwitcher({
    Key? key,
    required this.child,
    required this.switchKey,
    this.duration = const Duration(milliseconds: 520),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      transitionBuilder: (child, animation) {
        final fade = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        final slide = Tween<Offset>(
          begin: const Offset(0.03, 0),
          end: Offset.zero,
        ).animate(fade);
        final scale = Tween<double>(
          begin: 0.992,
          end: 1,
        ).animate(fade);

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: ScaleTransition(
              scale: scale,
              child: child,
            ),
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey<Object>(switchKey),
        child: child,
      ),
    );
  }
}
