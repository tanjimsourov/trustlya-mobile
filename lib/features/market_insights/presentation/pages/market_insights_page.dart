import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../cubit/market_insights_cubit.dart';
import '../cubit/market_insights_state.dart';
import '../../domain/entities/insight_item.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/cards.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Screen showing market insights and trends across all modules. It
/// displays top movers, volatility indicators and educational blurbs.
class MarketInsightsPage extends StatelessWidget {
  const MarketInsightsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MarketInsightsCubit>(
      create: (_) => MarketInsightsCubit(getIt()),
      child: BlocBuilder<MarketInsightsCubit, MarketInsightsState>(
        builder: (context, state) {
          Widget body;
          switch (state.status) {
            case Status.loading:
              body = const LoadingWidget();
              break;
            case Status.error:
              body = shared.ErrorWidgetView(message: state.message);
              break;
            case Status.empty:
              body = const EmptyWidget();
              break;
            case Status.success:
              final data = state.data!;
              body = SingleChildScrollView(
                child: ResponsivePageWrapper(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Market Insights',
                          style: AppTypography.h3
                              .copyWith(color: AppColorsDS.textPrimary)),
                      const SizedBox(height: AppSpacing.md),
                      _buildSection('Top Movers', data.topMovers),
                      const SizedBox(height: AppSpacing.lg),
                      _buildSection('Volatility Watch', data.volatility),
                      const SizedBox(height: AppSpacing.lg),
                      Text('Insights & Tips',
                          style: AppTypography.subtitle1
                              .copyWith(color: AppColorsDS.textPrimary)),
                      const SizedBox(height: AppSpacing.sm),
                      Column(
                        children: data.blurbs
                            .map((b) => Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppSpacing.sm),
                                  child: AppCard(
                                    padding:
                                        const EdgeInsets.all(AppSpacing.md),
                                    child: Text(
                                      b,
                                      style: AppTypography.body2.copyWith(
                                          color: AppColorsDS.textSecondary),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              );
              break;
            default:
              body = const LoadingWidget();
          }
          return AppScaffold(
            appBar: AppBar(title: const Text('Market Insights')),
            body: body,
          );
        },
      ),
    );
  }

  /// Helper to build a list section of insight items with their value
  /// and change percentages.
  Widget _buildSection(String title, List<InsightItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: AppTypography.subtitle1
                .copyWith(color: AppColorsDS.textPrimary)),
        const SizedBox(height: AppSpacing.sm),
        Column(
          children: items.map((item) {
            final color =
                item.change >= 0 ? AppColorsDS.success : AppColorsDS.danger;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: AppCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Icon(Icons.trending_up, color: color),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name,
                              style: AppTypography.subtitle2
                                  .copyWith(color: AppColorsDS.textPrimary)),
                          const SizedBox(height: 2),
                          Text('${item.type} • ${item.extra}',
                              style: AppTypography.caption
                                  .copyWith(color: AppColorsDS.textSecondary)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('\$${item.value.toStringAsFixed(2)}',
                            style: AppTypography.subtitle2
                                .copyWith(color: AppColorsDS.textPrimary)),
                        const SizedBox(height: 2),
                        Text(
                          '${item.change >= 0 ? '+' : ''}${item.change.toStringAsFixed(2)}%',
                          style: AppTypography.caption.copyWith(color: color),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
