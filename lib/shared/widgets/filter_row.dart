import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import 'chips.dart';

class FilterRow extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const FilterRow({
    Key? key,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          options.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: AppChip(
              label: options[index],
              selected: index == selectedIndex,
              onTap: () => onSelected(index),
            ),
          ),
        ),
      ),
    );
  }
}
