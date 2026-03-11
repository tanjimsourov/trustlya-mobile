import 'package:flutter/material.dart';

import '../../core/constants/strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'buttons.dart';

class EmptyWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  const EmptyWidget({
    Key? key,
    this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.inbox_outlined,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: AppColorsDS.accentSlateSoft,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColorsDS.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(title ?? 'Nothing to review',
                style: AppTypography.h4, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message ?? Strings.empty,
              style: AppTypography.body2
                  .copyWith(color: AppColorsDS.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}
