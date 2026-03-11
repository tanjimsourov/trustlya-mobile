import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class SegmentedControl<T> extends StatelessWidget {
  final List<T> values;
  final T selected;
  final ValueChanged<T> onChanged;
  final List<Widget> labels;

  const SegmentedControl({
    Key? key,
    required this.values,
    required this.selected,
    required this.onChanged,
    required this.labels,
  })  : assert(values.length == labels.length),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final index = values.indexOf(selected);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxs),
      decoration: BoxDecoration(
        color: AppColorsDS.surfaceElevated,
        borderRadius: AppRadii.large,
        border: Border.all(color: AppColorsDS.borderStrong),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final hasBoundedWidth = constraints.maxWidth.isFinite;
          final useWrap =
              !hasBoundedWidth || constraints.maxWidth < values.length * 96;

          if (useWrap) {
            final segmentWidth = hasBoundedWidth
                ? (constraints.maxWidth - AppSpacing.xxs) / 2
                : 132.0;
            return Wrap(
              spacing: AppSpacing.xxs,
              runSpacing: AppSpacing.xxs,
              children: List.generate(values.length, (i) {
                return SizedBox(
                  width: segmentWidth,
                  child: _SegmentButton<T>(
                    label: labels[i],
                    value: values[i],
                    selected: i == index,
                    onChanged: onChanged,
                  ),
                );
              }),
            );
          }

          return Row(
            children: List.generate(values.length, (i) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: i == 0 ? 0 : AppSpacing.xxs),
                  child: _SegmentButton<T>(
                    label: labels[i],
                    value: values[i],
                    selected: i == index,
                    onChanged: onChanged,
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class _SegmentButton<T> extends StatelessWidget {
  final Widget label;
  final T value;
  final bool selected;
  final ValueChanged<T> onChanged;

  const _SegmentButton({
    required this.label,
    required this.value,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadii.large,
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.mdSm,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColorsDS.primarySoft : Colors.transparent,
          borderRadius: AppRadii.large,
          border: selected ? Border.all(color: AppColorsDS.borderStrong) : null,
          boxShadow: selected ? AppShadows.low : null,
        ),
        child: DefaultTextStyle(
          style: AppTypography.caption.copyWith(
            color: selected ? AppColorsDS.primary : AppColorsDS.textSecondary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
          child: Center(child: label),
        ),
      ),
    );
  }
}
