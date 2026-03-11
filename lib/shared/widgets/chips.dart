import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class AppChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const AppChip({
    Key? key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.onDelete,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final background = backgroundColor ??
        (selected ? AppColorsDS.primarySoft : AppColorsDS.surfaceElevated);
    final foreground = textColor ??
        (selected ? AppColorsDS.primary : AppColorsDS.textSecondary);
    final border = borderColor ??
        (selected
            ? AppColorsDS.primary.withOpacity(0.15)
            : AppColorsDS.borderStrong);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadii.large,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.mdSm,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: AppRadii.large,
            border: Border.all(color: border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: foreground),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(label,
                  style: AppTypography.caption.copyWith(color: foreground)),
              if (onDelete != null) ...[
                const SizedBox(width: AppSpacing.xs),
                InkWell(
                  onTap: onDelete,
                  child: Icon(Icons.close, size: 14, color: foreground),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
