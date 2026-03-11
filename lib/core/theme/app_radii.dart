import 'package:flutter/material.dart';

/// Shared corner radii used throughout the design system.
class AppRadii {
  AppRadii._();

  static const double xs = 8.0;
  static const double sm = 10.0;
  static const double md = 14.0;
  static const double lg = 20.0;
  static const double xl = 28.0;

  static BorderRadius get xSmall => BorderRadius.circular(xs);
  static BorderRadius get small => BorderRadius.circular(sm);
  static BorderRadius get medium => BorderRadius.circular(md);
  static BorderRadius get large => BorderRadius.circular(lg);
  static BorderRadius get xLarge => BorderRadius.circular(xl);
}
