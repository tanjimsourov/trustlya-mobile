import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Defines reusable linear gradients for backgrounds and accent areas.
class AppGradients {
  AppGradients._();

  /// Primary gradient blending the brand primary colours.
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColorsDS.primary, AppColorsDS.primaryVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Secondary gradient used for accent surfaces and highlights.
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [AppColorsDS.secondary, AppColorsDS.secondaryVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
