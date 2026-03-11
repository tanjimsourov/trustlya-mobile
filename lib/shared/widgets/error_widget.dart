import 'package:flutter/material.dart';

import '../../core/constants/strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'buttons.dart';
import 'cards.dart';
import 'motion.dart';

class ErrorWidgetView extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onRetry;

  const ErrorWidgetView({
    Key? key,
    this.title,
    this.message,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MotionReveal(
        duration: const Duration(milliseconds: 740),
        beginOffset: const Offset(0, 0.03),
        beginBlur: 10,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: AppCard(
            borderColor: AppColorsDS.borderStrong,
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: AppColorsDS.accentRedSoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.error_outline,
                      color: AppColorsDS.danger),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(title ?? 'Unable to load this view',
                    style: AppTypography.h4, textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  message ?? Strings.error,
                  style: AppTypography.body2
                      .copyWith(color: AppColorsDS.textSecondary),
                  textAlign: TextAlign.center,
                ),
                if (onRetry != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(label: 'Retry', onPressed: onRetry),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
