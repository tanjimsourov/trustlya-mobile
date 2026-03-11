import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'cards.dart';
import 'motion.dart';

class LoadingWidget extends StatelessWidget {
  final String? label;

  const LoadingWidget({Key? key, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MotionReveal(
        duration: const Duration(milliseconds: 720),
        beginOffset: const Offset(0, 0.03),
        beginBlur: 10,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
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
                    color: AppColorsDS.primarySoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    ),
                  ),
                ),
                if (label != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    label!,
                    style: AppTypography.body2
                        .copyWith(color: AppColorsDS.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
