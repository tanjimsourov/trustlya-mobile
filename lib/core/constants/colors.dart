import 'package:flutter/material.dart';

/// Defines the colour palette used throughout Trustlya.
class AppColors {
  AppColors._();

  // Primary brand colours reminiscent of fintech and crypto trading apps.
  static const Color primary = Color(0xFF2565AE); // deep blue
  static const Color primaryLight = Color(0xFF4A90E2);
  static const Color secondary = Color(0xFF20C997); // teal/green accent

  // Backgrounds
  static const Color background = Color(0xFFF5F7FA);
  static const Color backgroundDark = Color(0xFF0B253F);

  // Greyscale
  static const Color grey1 = Color(0xFFFAFAFA);
  static const Color grey2 = Color(0xFFEFEFEF);
  static const Color grey3 = Color(0xFFBDBDBD);
  static const Color grey4 = Color(0xFF757575);

  // Alerts
  static const Color error = Color(0xFFEB5757);
  static const Color warning = Color(0xFFF2994A);
  static const Color success = Color(0xFF27AE60);
}
