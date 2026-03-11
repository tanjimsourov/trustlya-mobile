import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Shared type ramp for the app.
class AppTypography {
  AppTypography._();

  static const TextStyle h1 = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColorsDS.textPrimary,
    height: 1.08,
    letterSpacing: -0.8,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: AppColorsDS.textPrimary,
    height: 1.12,
    letterSpacing: -0.6,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColorsDS.textPrimary,
    height: 1.16,
    letterSpacing: -0.4,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColorsDS.textPrimary,
    height: 1.2,
    letterSpacing: -0.2,
  );

  static const TextStyle h5 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColorsDS.textPrimary,
    height: 1.25,
  );

  static const TextStyle h6 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColorsDS.textPrimary,
    height: 1.25,
  );

  static const TextStyle subtitle1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColorsDS.textPrimary,
    height: 1.4,
  );

  static const TextStyle subtitle2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColorsDS.textSecondary,
    height: 1.35,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColorsDS.textPrimary,
    height: 1.55,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColorsDS.textSecondary,
    height: 1.55,
  );

  static const TextStyle button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColorsDS.white,
    height: 1.2,
    letterSpacing: 0.1,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColorsDS.textSecondary,
    height: 1.45,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: 0.8,
    color: AppColorsDS.textSecondary,
  );

  static const TextStyle mono = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColorsDS.textPrimary,
    fontFamily: 'monospace',
  );
}
