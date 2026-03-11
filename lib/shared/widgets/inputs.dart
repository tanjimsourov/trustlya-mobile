import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool enabled;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  const AppTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
  }) : super(key: key);

  InputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: AppRadii.medium,
      borderSide: BorderSide(color: color, width: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      maxLines: obscureText ? 1 : maxLines,
      style: AppTypography.body1.copyWith(color: AppColorsDS.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        hintStyle:
            AppTypography.body2.copyWith(color: AppColorsDS.textSecondary),
        filled: true,
        fillColor: AppColorsDS.surface,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColorsDS.textSecondary, size: 18)
            : null,
        suffixIcon: suffixIcon != null
            ? InkWell(
                onTap: onSuffixTap,
                child: Icon(suffixIcon,
                    color: AppColorsDS.textSecondary, size: 18),
              )
            : null,
        enabledBorder: _buildBorder(AppColorsDS.border),
        focusedBorder: _buildBorder(AppColorsDS.primary),
        disabledBorder: _buildBorder(AppColorsDS.disabled),
        errorBorder: _buildBorder(AppColorsDS.danger),
        focusedErrorBorder: _buildBorder(AppColorsDS.danger),
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSpacing.mdSm,
          horizontal: AppSpacing.md,
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;

  const SearchField({
    Key? key,
    required this.controller,
    this.onChanged,
    this.hintText = 'Search',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: hintText,
      prefixIcon: Icons.search,
      suffixIcon: controller.text.isNotEmpty ? Icons.close : null,
      onChanged: onChanged,
      onSuffixTap: () {
        controller.clear();
        onChanged?.call('');
      },
    );
  }
}

class AmountInput extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final Widget? prefix;
  final ValueChanged<String>? onChanged;

  const AmountInput({
    Key? key,
    required this.controller,
    this.hintText,
    this.prefix,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (prefix != null) ...[
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.mdSm),
            child: prefix!,
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
        Expanded(
          child: AppTextField(
            controller: controller,
            hintText: hintText ?? '0.00',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class OtpInput extends StatefulWidget {
  final int length;
  final ValueChanged<String> onChanged;

  const OtpInput({Key? key, this.length = 6, required this.onChanged})
      : super(key: key);

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late final List<FocusNode> _nodes;
  late final List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _nodes = List.generate(widget.length, (_) => FocusNode());
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    for (final controller in _controllers) {
      controller.addListener(_notify);
    }
  }

  void _notify() {
    widget.onChanged(_controllers.map((c) => c.text).join());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _nodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 46,
          child: TextField(
            controller: _controllers[index],
            focusNode: _nodes[index],
            maxLength: 1,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: AppTypography.h4,
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: AppColorsDS.surface,
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadii.small,
                borderSide: const BorderSide(color: AppColorsDS.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadii.small,
                borderSide: const BorderSide(color: AppColorsDS.primary),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < widget.length - 1) {
                _nodes[index + 1].requestFocus();
              } else if (value.isEmpty && index > 0) {
                _nodes[index - 1].requestFocus();
              }
            },
          ),
        );
      }),
    );
  }
}

class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;

  const AppDropdown({
    Key? key,
    this.value,
    required this.items,
    this.onChanged,
    this.hint,
  }) : super(key: key);

  InputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: AppRadii.medium,
      borderSide: BorderSide(color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      isExpanded: true,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColorsDS.surface,
        enabledBorder: _buildBorder(AppColorsDS.border),
        focusedBorder: _buildBorder(AppColorsDS.primary),
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSpacing.mdSm,
          horizontal: AppSpacing.md,
        ),
      ),
      dropdownColor: AppColorsDS.surface,
      iconEnabledColor: AppColorsDS.textSecondary,
      iconDisabledColor: AppColorsDS.disabled,
      style: AppTypography.body1.copyWith(color: AppColorsDS.textPrimary),
    );
  }
}
