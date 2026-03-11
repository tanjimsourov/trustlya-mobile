import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'buttons.dart';

/// A sticky call‑to‑action footer that stays fixed to the bottom of the
/// screen. It exposes a child widget which is typically a [PrimaryButton].
class StickyCTA extends StatelessWidget {
  final Widget child;
  const StickyCTA({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColorsDS.surface,
      padding: const EdgeInsets.all(AppSpacing.md),
      width: double.infinity,
      child: SafeArea(
        top: false,
        child: Center(child: child),
      ),
    );
  }
}
