import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radii.dart';
import 'app_typography.dart';

/// Ready-to-use theme definitions for the shared design system.
class DesignSystemTheme {
  DesignSystemTheme._();

  static ThemeData get lightTheme => _buildTheme(Brightness.light);

  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final background =
        isDark ? const Color(0xFF0C1728) : AppColorsDS.background;
    final surface = isDark ? const Color(0xFF132134) : AppColorsDS.surface;
    final card = isDark ? const Color(0xFF17273B) : AppColorsDS.surfaceElevated;
    final textPrimary = isDark ? AppColorsDS.white : AppColorsDS.textPrimary;
    final textSecondary =
        isDark ? const Color(0xFFB6C0D4) : AppColorsDS.textSecondary;

    final scheme = ColorScheme(
      brightness: brightness,
      primary: AppColorsDS.primary,
      onPrimary: AppColorsDS.white,
      secondary: AppColorsDS.secondary,
      onSecondary: AppColorsDS.white,
      error: AppColorsDS.danger,
      onError: AppColorsDS.white,
      surface: surface,
      onSurface: textPrimary,
      background: background,
      onBackground: textPrimary,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      dividerColor: isDark ? Colors.white12 : AppColorsDS.divider,
      cardColor: card,
      splashFactory: InkSparkle.splashFactory,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _AppPageTransitionsBuilder(),
          TargetPlatform.iOS: _AppPageTransitionsBuilder(),
          TargetPlatform.macOS: _AppPageTransitionsBuilder(),
          TargetPlatform.windows: _AppPageTransitionsBuilder(),
          TargetPlatform.linux: _AppPageTransitionsBuilder(),
        },
      ),
    );

    return base.copyWith(
      primaryColor: AppColorsDS.primary,
      textTheme: TextTheme(
        headlineLarge: AppTypography.h1.copyWith(color: textPrimary),
        headlineMedium: AppTypography.h2.copyWith(color: textPrimary),
        headlineSmall: AppTypography.h3.copyWith(color: textPrimary),
        titleLarge: AppTypography.h4.copyWith(color: textPrimary),
        titleMedium: AppTypography.h5.copyWith(color: textPrimary),
        titleSmall: AppTypography.subtitle2.copyWith(color: textSecondary),
        bodyLarge: AppTypography.body1.copyWith(color: textPrimary),
        bodyMedium: AppTypography.body2.copyWith(color: textSecondary),
        labelLarge: AppTypography.button,
        labelSmall: AppTypography.overline.copyWith(color: textSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.h4.copyWith(color: textPrimary),
        iconTheme: IconThemeData(color: textPrimary),
        actionsIconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardTheme(
        color: card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.large,
          side: BorderSide(
            color: isDark ? Colors.white10 : AppColorsDS.border,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsDS.primary,
          foregroundColor: AppColorsDS.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(50),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.large),
          textStyle: AppTypography.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColorsDS.primary,
          backgroundColor:
              isDark ? const Color(0xFF17273B) : AppColorsDS.primarySoft,
          minimumSize: const Size.fromHeight(50),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          side: BorderSide(
              color: isDark ? Colors.white24 : AppColorsDS.borderStrong),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.large),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColorsDS.primary,
          textStyle: AppTypography.subtitle2.copyWith(
            color: AppColorsDS.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark
            ? const Color(0xEE132134)
            : AppColorsDS.surface.withOpacity(0.96),
        surfaceTintColor: Colors.transparent,
        indicatorColor: isDark ? Colors.white12 : AppColorsDS.accentBlueSoft,
        elevation: 0,
        height: 76,
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          final selected = states.contains(MaterialState.selected);
          return AppTypography.caption.copyWith(
            color: selected ? AppColorsDS.primary : textSecondary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          );
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          final selected = states.contains(MaterialState.selected);
          return IconThemeData(
            color: selected ? AppColorsDS.primary : textSecondary,
            size: 24,
          );
        }),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor:
            isDark ? const Color(0xFF17273B) : AppColorsDS.surfaceMuted,
        selectedColor:
            isDark ? const Color(0xFF1F3551) : AppColorsDS.accentBlueSoft,
        side: BorderSide(
          color: isDark ? Colors.white12 : AppColorsDS.border,
        ),
        labelStyle: AppTypography.caption.copyWith(color: textPrimary),
        shape: RoundedRectangleBorder(borderRadius: AppRadii.large),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor:
            isDark ? const Color(0xFF18283D) : AppColorsDS.surfaceElevated,
        hintStyle: AppTypography.body2.copyWith(color: textSecondary),
        labelStyle: AppTypography.body2.copyWith(color: textSecondary),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: AppRadii.large,
          borderSide:
              BorderSide(color: isDark ? Colors.white12 : AppColorsDS.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.large,
          borderSide:
              BorderSide(color: isDark ? Colors.white12 : AppColorsDS.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.large,
          borderSide: const BorderSide(color: AppColorsDS.primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadii.large,
          borderSide: const BorderSide(color: AppColorsDS.danger),
        ),
      ),
    );
  }
}

class _AppPageTransitionsBuilder extends PageTransitionsBuilder {
  const _AppPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (disableAnimations) {
      return child;
    }

    final fade = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    final incomingSlide = Tween<Offset>(
      begin: const Offset(0.035, 0),
      end: Offset.zero,
    ).animate(fade);
    final incomingScale = Tween<double>(
      begin: 0.992,
      end: 1,
    ).animate(fade);
    final outgoingSlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.014, 0),
    ).animate(
      CurvedAnimation(
        parent: secondaryAnimation,
        curve: Curves.easeOutCubic,
      ),
    );
    final blur = Tween<double>(
      begin: 8,
      end: 0,
    ).animate(fade);

    return SlideTransition(
      position: outgoingSlide,
      child: FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: incomingSlide,
          child: ScaleTransition(
            scale: incomingScale,
            child: AnimatedBuilder(
              animation: blur,
              child: child,
              builder: (context, child) {
                return ImageFiltered(
                  imageFilter:
                      ImageFilter.blur(sigmaX: blur.value, sigmaY: blur.value),
                  child: child,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
