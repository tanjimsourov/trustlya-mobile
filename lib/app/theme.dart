import 'package:flutter/material.dart';
// The new design system theme defines all colour and typography tokens.
import '../core/theme/design_system_theme.dart';

/// Centralised theme definitions for Trustlya.
/// TrustlyaTheme now wraps the design system's themes. It provides the
/// application level light and dark themes used by the MaterialApp. By
/// funnelling through our design system we ensure all widgets use the
/// same token definitions.
class TrustlyaTheme {
  TrustlyaTheme._();

  /// Light theme forwarding to the design system. Even though the design
  /// system is dark‑first, a light variant is provided for completeness.
  static ThemeData get lightTheme => DesignSystemTheme.lightTheme;

  /// Dark theme for the application that uses the design system palette.
  static ThemeData get darkTheme => DesignSystemTheme.darkTheme;
}
