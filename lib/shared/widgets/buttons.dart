import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

enum ButtonType { primary, secondary, ghost, destructive }

class AppButton extends StatelessWidget {
  final ButtonType type;
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool disabled;
  final bool? enabled;
  final IconData? icon;
  final bool fullWidth;

  const AppButton({
    Key? key,
    String? label,
    String? text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.loading = false,
    this.disabled = false,
    this.enabled,
    this.icon,
    this.fullWidth = true,
  })  : assert(label != null || text != null,
            'Either label or text must be provided.'),
        label = label ?? text ?? '',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDisabled =
        disabled || enabled == false || loading || onPressed == null;
    final style = _styleFor(type, isDisabled);
    final child = loading
        ? SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(_foregroundFor(type)),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: AppSpacing.sm),
              ],
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            ],
          );

    final button = type == ButtonType.ghost
        ? OutlinedButton(
            onPressed: isDisabled ? null : onPressed,
            style: style,
            child: child,
          )
        : ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: style,
            child: child,
          );

    if (!fullWidth) {
      return button;
    }
    return SizedBox(width: double.infinity, child: button);
  }

  ButtonStyle _styleFor(ButtonType type, bool isDisabled) {
    final foreground = _foregroundFor(type);
    final background = _backgroundFor(type);
    final border = _borderFor(type);
    final disabledOpacity = isDisabled ? 0.5 : 1.0;
    final elevation = type == ButtonType.ghost || isDisabled ? 0.0 : 2.0;

    return ButtonStyle(
      minimumSize: MaterialStateProperty.all(const Size.fromHeight(50)),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      ),
      textStyle: MaterialStateProperty.all(AppTypography.button),
      elevation: MaterialStateProperty.all(elevation),
      shadowColor:
          MaterialStateProperty.all(AppColorsDS.primary.withOpacity(0.14)),
      backgroundColor:
          MaterialStateProperty.all(background.withOpacity(disabledOpacity)),
      foregroundColor:
          MaterialStateProperty.all(foreground.withOpacity(disabledOpacity)),
      overlayColor: MaterialStateProperty.all(foreground.withOpacity(0.08)),
      side: MaterialStateProperty.all(
          BorderSide(color: border.withOpacity(disabledOpacity))),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: AppRadii.large),
      ),
    );
  }

  Color _backgroundFor(ButtonType type) {
    switch (type) {
      case ButtonType.primary:
        return AppColorsDS.primary;
      case ButtonType.secondary:
        return AppColorsDS.secondary;
      case ButtonType.ghost:
        return AppColorsDS.primarySoft;
      case ButtonType.destructive:
        return AppColorsDS.danger;
    }
  }

  Color _foregroundFor(ButtonType type) {
    switch (type) {
      case ButtonType.primary:
      case ButtonType.secondary:
      case ButtonType.destructive:
        return AppColorsDS.white;
      case ButtonType.ghost:
        return AppColorsDS.primary;
    }
  }

  Color _borderFor(ButtonType type) {
    switch (type) {
      case ButtonType.primary:
      case ButtonType.secondary:
      case ButtonType.destructive:
        return Colors.transparent;
      case ButtonType.ghost:
        return AppColorsDS.borderStrong;
    }
  }
}

class PrimaryButton extends AppButton {
  const PrimaryButton({
    Key? key,
    String? label,
    String? text,
    VoidCallback? onPressed,
    bool loading = false,
    bool disabled = false,
    bool? enabled,
    IconData? icon,
    bool fullWidth = true,
  }) : super(
          key: key,
          label: label,
          text: text,
          onPressed: onPressed,
          type: ButtonType.primary,
          loading: loading,
          disabled: disabled,
          enabled: enabled,
          icon: icon,
          fullWidth: fullWidth,
        );
}

class SecondaryButton extends AppButton {
  const SecondaryButton({
    Key? key,
    String? label,
    String? text,
    VoidCallback? onPressed,
    bool loading = false,
    bool disabled = false,
    bool? enabled,
    IconData? icon,
    bool fullWidth = true,
  }) : super(
          key: key,
          label: label,
          text: text,
          onPressed: onPressed,
          type: ButtonType.secondary,
          loading: loading,
          disabled: disabled,
          enabled: enabled,
          icon: icon,
          fullWidth: fullWidth,
        );
}

class GhostButton extends AppButton {
  const GhostButton({
    Key? key,
    String? label,
    String? text,
    VoidCallback? onPressed,
    bool loading = false,
    bool disabled = false,
    bool? enabled,
    IconData? icon,
    bool fullWidth = true,
  }) : super(
          key: key,
          label: label,
          text: text,
          onPressed: onPressed,
          type: ButtonType.ghost,
          loading: loading,
          disabled: disabled,
          enabled: enabled,
          icon: icon,
          fullWidth: fullWidth,
        );
}

class DestructiveButton extends AppButton {
  const DestructiveButton({
    Key? key,
    String? label,
    String? text,
    VoidCallback? onPressed,
    bool loading = false,
    bool disabled = false,
    bool? enabled,
    IconData? icon,
    bool fullWidth = true,
  }) : super(
          key: key,
          label: label,
          text: text,
          onPressed: onPressed,
          type: ButtonType.destructive,
          loading: loading,
          disabled: disabled,
          enabled: enabled,
          icon: icon,
          fullWidth: fullWidth,
        );
}
