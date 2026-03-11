import 'package:flutter/material.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/dialogs.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/trade.dart';
import '../../domain/repositories/item_trading_repository.dart';
import '../cubit/trade_builder_state.dart';

/// Review page for confirming a trade. Displays the lists of offered and
/// requested items, calculates totals and fees, and allows the user to
/// finalise the trade. On confirmation the trade is created via the
/// repository and a success dialog is shown. Navigates to the trade
/// history afterwards.
class TradeReviewPage extends StatelessWidget {
  final TradeBuilderState tradeState;
  const TradeReviewPage({Key? key, required this.tradeState}) : super(key: key);

  Future<void> _confirmTrade(BuildContext context) async {
    final repo = getIt<ItemTradingRepository>();
    final result =
        await repo.createTrade(tradeState.offered, tradeState.requested);
    if (result is Success<Trade>) {
      await showSuccessDialog(
        context,
        title: 'Trade Successful',
        message: 'Your trade has been completed successfully.',
      );
      // Navigate to trade history and clear back stack up to dashboard
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.tradeHistory,
          ModalRoute.withName(Routes.itemTradingDashboard));
    } else if (result is Error<Trade>) {
      showAppSnackBar(context,
          message: result.message ?? 'Failed to complete trade');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate fee as 5% of the requested value
    final double fee = tradeState.requestedValue * 0.05;
    final double total = tradeState.requestedValue + fee;
    final diff = tradeState.offeredValue - tradeState.requestedValue;
    final diffColor = diff >= 0 ? AppColorsDS.success : AppColorsDS.danger;
    return AppScaffold(
      appBar: AppBar(title: const Text('Review Trade')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Offered Items', style: AppTypography.subtitle1),
              const SizedBox(height: AppSpacing.sm),
              if (tradeState.offered.isEmpty)
                Text('None',
                    style: AppTypography.body2
                        .copyWith(color: AppColorsDS.textSecondary))
              else
                Column(
                  children: tradeState.offered
                      .map((item) => _buildItemRow(item))
                      .toList(),
                ),
              const SizedBox(height: AppSpacing.lg),
              Text('Requested Items', style: AppTypography.subtitle1),
              const SizedBox(height: AppSpacing.sm),
              if (tradeState.requested.isEmpty)
                Text('None',
                    style: AppTypography.body2
                        .copyWith(color: AppColorsDS.textSecondary))
              else
                Column(
                  children: tradeState.requested
                      .map((item) => _buildItemRow(item))
                      .toList(),
                ),
              const SizedBox(height: AppSpacing.lg),
              // Totals and fee
              Text('Summary', style: AppTypography.subtitle1),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Offered Value',
                      style: AppTypography.body2
                          .copyWith(color: AppColorsDS.textSecondary)),
                  Text('\$${tradeState.offeredValue.toStringAsFixed(0)}',
                      style: AppTypography.body1),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Requested Value',
                      style: AppTypography.body2
                          .copyWith(color: AppColorsDS.textSecondary)),
                  Text('\$${tradeState.requestedValue.toStringAsFixed(0)}',
                      style: AppTypography.body1),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Trade Fee (5%)',
                      style: AppTypography.body2
                          .copyWith(color: AppColorsDS.textSecondary)),
                  Text('\$${fee.toStringAsFixed(0)}',
                      style: AppTypography.body1),
                ],
              ),
              const Divider(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Due', style: AppTypography.subtitle1),
                  Text('\$${total.toStringAsFixed(0)}',
                      style: AppTypography.subtitle1),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Icon(
                    diff >= 0 ? Icons.check_circle : Icons.warning,
                    color: diff >= 0 ? AppColorsDS.success : AppColorsDS.danger,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      diff >= 0
                          ? 'Your offered value exceeds the requested value by \$${diff.toStringAsFixed(0)}.'
                          : 'Your offered value is lower than the requested value by \$${(-diff).toStringAsFixed(0)}.',
                      style: AppTypography.body2.copyWith(color: diffColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Confirm Trade',
                onPressed: () => _confirmTrade(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a row representing an item in the review summary.
  Widget _buildItemRow(Item item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 40,
                  width: 40,
                  color: AppColorsDS.surface,
                  child: const Icon(Icons.image_not_supported, size: 16),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(item.name, style: AppTypography.body1),
            ),
            Text('\$${item.price.toStringAsFixed(0)}',
                style:
                    AppTypography.body1.copyWith(color: AppColorsDS.primary)),
          ],
        ),
      ),
    );
  }
}
