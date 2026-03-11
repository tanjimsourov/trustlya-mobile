import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/cards.dart';
import '../../domain/entities/trade.dart';

/// A card summarising a trade. Displays the number of items offered
/// and received, the counterparties, total values and the status
/// badge. The value difference is colour coded to indicate profit or
/// loss from the user’s perspective.
class TradeSummaryCard extends StatelessWidget {
  final Trade trade;
  const TradeSummaryCard({Key? key, required this.trade}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final diff = trade.offeredValue - trade.requestedValue;
    final diffColor = diff >= 0 ? AppColorsDS.success : AppColorsDS.danger;
    final diffLabel = diff >= 0
        ? '+\$${diff.toStringAsFixed(0)}'
        : '-\$${(-diff).toStringAsFixed(0)}';
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'With ${trade.counterparty}',
                  style: AppTypography.subtitle1,
                ),
                const SizedBox(height: 2),
                Text(
                  '${trade.offered.length} → ${trade.requested.length} items',
                  style: AppTypography.body2
                      .copyWith(color: AppColorsDS.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  '${trade.date.day}/${trade.date.month}/${trade.date.year}',
                  style: AppTypography.caption
                      .copyWith(color: AppColorsDS.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${trade.offeredValue.toStringAsFixed(0)}',
                style: AppTypography.subtitle1,
              ),
              const Icon(Icons.arrow_forward,
                  size: 16, color: AppColorsDS.textSecondary),
              Text(
                '\$${trade.requestedValue.toStringAsFixed(0)}',
                style: AppTypography.subtitle1,
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: trade.status == 'completed'
                      ? AppColorsDS.success.withOpacity(0.2)
                      : trade.status == 'pending'
                          ? AppColorsDS.info.withOpacity(0.2)
                          : AppColorsDS.danger.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  trade.status.toUpperCase(),
                  style: AppTypography.caption.copyWith(
                    color: trade.status == 'completed'
                        ? AppColorsDS.success
                        : trade.status == 'pending'
                            ? AppColorsDS.info
                            : AppColorsDS.danger,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                diffLabel,
                style: AppTypography.subtitle2.copyWith(color: diffColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
