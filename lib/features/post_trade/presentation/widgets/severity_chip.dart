import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/settlement_exception.dart';
import '../../domain/entities/counterparty_exposure.dart';

/// A small chip widget used to display the severity of an exception. The
/// colour of the chip reflects the severity level using semantic
/// colours from the design system.
class SeverityChip extends StatelessWidget {
  final ExceptionSeverity severity;
  const SeverityChip({Key? key, required this.severity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color colour;
    String label;
    switch (severity) {
      case ExceptionSeverity.low:
        colour = AppColorsDS.success;
        label = 'Low';
        break;
      case ExceptionSeverity.medium:
        colour = AppColorsDS.warning;
        label = 'Medium';
        break;
      case ExceptionSeverity.high:
        colour = AppColorsDS.danger;
        label = 'High';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: colour.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: AppTypography.caption.copyWith(color: colour)),
    );
  }
}

/// A small chip widget used to display the risk level of a counterparty
/// exposure. Shares the same colour palette as [SeverityChip].
class RiskLevelChip extends StatelessWidget {
  final RiskLevel level;
  const RiskLevelChip({Key? key, required this.level}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color colour;
    String label;
    switch (level) {
      case RiskLevel.low:
        colour = AppColorsDS.success;
        label = 'Low';
        break;
      case RiskLevel.medium:
        colour = AppColorsDS.warning;
        label = 'Medium';
        break;
      case RiskLevel.high:
        colour = AppColorsDS.danger;
        label = 'High';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: colour.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: AppTypography.caption.copyWith(color: colour)),
    );
  }
}
