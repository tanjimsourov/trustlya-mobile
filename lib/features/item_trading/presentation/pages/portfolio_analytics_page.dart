import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../domain/entities/portfolio_analytics.dart';
import '../../domain/entities/item.dart';
import '../cubit/portfolio_analytics_cubit.dart';
import '../cubit/portfolio_analytics_state.dart';
import '../widgets/item_card.dart';

/// Presents portfolio analytics for game items including profit/loss
/// summary, performance over time, rarity distribution and best
/// performing items. Uses [PortfolioAnalyticsCubit] to load mock data.
class PortfolioAnalyticsPage extends StatelessWidget {
  const PortfolioAnalyticsPage({Key? key}) : super(key: key);

  Color _rarityColor(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'covert':
        return AppColorsDS.primary;
      case 'classified':
        return AppColorsDS.success;
      case 'restricted':
        return AppColorsDS.warning;
      case 'common':
        return AppColorsDS.textSecondary;
      default:
        return AppColorsDS.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PortfolioAnalyticsCubit>(
      create: (_) => getIt<PortfolioAnalyticsCubit>()..loadAnalytics(),
      child: BlocBuilder<PortfolioAnalyticsCubit, PortfolioAnalyticsState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const LoadingWidget();
          }
          if (state.status == Status.error) {
            return shared.ErrorWidgetView(message: state.message);
          }
          if (state.status == Status.success && state.data != null) {
            final PortfolioAnalytics analytics = state.data!;
            // Extract performance values
            final values =
                analytics.performance.map((e) => e.values.first).toList();
            final maxValue = values.reduce(max);
            final minValue = values.reduce(min);
            return AppScaffold(
              appBar: AppBar(title: const Text('Portfolio Analytics')),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profit/Loss summary
                      Row(
                        children: [
                          Expanded(
                            child: MetricCard(
                              title: 'Total Profit',
                              value:
                                  '\$${analytics.totalProfit.toStringAsFixed(0)}',
                              icon: Icons.arrow_upward,
                              iconColor: AppColorsDS.success,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: MetricCard(
                              title: 'Total Loss',
                              value:
                                  '\$${analytics.totalLoss.toStringAsFixed(0)}',
                              icon: Icons.arrow_downward,
                              iconColor: AppColorsDS.danger,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Performance chart
                      Text('Performance (7d)', style: AppTypography.subtitle1),
                      const SizedBox(height: AppSpacing.sm),
                      SizedBox(
                        height: 80,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (final v in values) ...[
                              Expanded(
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  height: maxValue == 0
                                      ? 0
                                      : 60 *
                                          ((v - minValue) /
                                              (maxValue - minValue + 1)),
                                  decoration: BoxDecoration(
                                    color: AppColorsDS.primary.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Rarity distribution
                      Text('Rarity Distribution',
                          style: AppTypography.subtitle1),
                      const SizedBox(height: AppSpacing.sm),
                      Column(
                        children:
                            analytics.rarityDistribution.entries.map((entry) {
                          final count = entry.value;
                          final maxCount =
                              analytics.rarityDistribution.values.reduce(max);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                SizedBox(
                                    width: 80,
                                    child: Text(entry.key,
                                        style: AppTypography.body2)),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Container(
                                    height: 8,
                                    width: double.infinity,
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      color: AppColorsDS.surface,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor:
                                          maxCount == 0 ? 0 : count / maxCount,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: _rarityColor(entry.key)
                                              .withOpacity(0.7),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Text(count.toString(),
                                    style: AppTypography.body2),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Best items
                      Text('Best Performing Items',
                          style: AppTypography.subtitle1),
                      const SizedBox(height: AppSpacing.sm),
                      SizedBox(
                        height: 240,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: analytics.bestItems.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: AppSpacing.md),
                          itemBuilder: (_, index) {
                            final Item item = analytics.bestItems[index];
                            return SizedBox(
                              width: 180,
                              child: ItemCard(
                                item: item,
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      Routes.itemDetail,
                                      arguments: item.id);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
