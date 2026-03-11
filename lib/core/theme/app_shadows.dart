import 'package:flutter/material.dart';

/// Shared surface elevations for cards, panels and overlays.
class AppShadows {
  AppShadows._();

  static const Color _shadowColor = Color(0x14263B56);
  static const Color _shadowColorSoft = Color(0x0A263B56);

  static List<BoxShadow> get low => const [
        BoxShadow(
          color: _shadowColor,
          blurRadius: 18,
          offset: Offset(0, 8),
        ),
        BoxShadow(
          color: _shadowColorSoft,
          blurRadius: 4,
          offset: Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get medium => const [
        BoxShadow(
          color: _shadowColor,
          blurRadius: 28,
          offset: Offset(0, 12),
        ),
        BoxShadow(
          color: _shadowColorSoft,
          blurRadius: 8,
          offset: Offset(0, 3),
        ),
      ];

  static List<BoxShadow> get high => const [
        BoxShadow(
          color: _shadowColor,
          blurRadius: 40,
          offset: Offset(0, 18),
        ),
        BoxShadow(
          color: _shadowColorSoft,
          blurRadius: 12,
          offset: Offset(0, 5),
        ),
      ];
}
