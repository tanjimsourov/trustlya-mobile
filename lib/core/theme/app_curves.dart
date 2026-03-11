import 'package:flutter/animation.dart';

/// Provides a set of common animation curves for various types of motion.
class AppCurves {
  AppCurves._();

  static const Curve standard = Curves.easeOutCubic;
  static const Curve deceleration = Curves.easeOutQuad;
  static const Curve acceleration = Curves.easeInCubic;
  static const Curve elastic = Curves.easeInOutBack;
}
