import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../app/routes.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../cubit/trading_dashboard_cubit.dart';
import '../cubit/trading_dashboard_state.dart';
import '../widgets/item_card.dart';
import '../widgets/trade_summary_card.dart';

/// Main dashboard for game item trading. Shows the total value of the
/// user’s inventory, recent performance, quick actions, trending
/// items, alerts and recent trades. Uses [TradingDashboardCubit] to
/// load mock data.
class TradingDashboardPage extends StatefulWidget {
  const TradingDashboardPage({Key? key}) : super(key: key);

  @override
  State<TradingDashboardPage> createState() => _TradingDashboardPageState();
}

class _TradingDashboardPageState extends State<TradingDashboardPage> {
  @override
  void initState() {
    super.initState();
    // Load dashboard data once page is built
    Future.microtask(
        () => context.read<TradingDashboardCubit>().loadDashboard());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TradingDashboardCubit>(
      create: (_) => getIt<TradingDashboardCubit>(),
      child: BlocBuilder<TradingDashboardCubit, TradingDashboardState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const LoadingWidget();
          }
          if (state.status == Status.error) {
            return shared.ErrorWidgetView(message: state.message);
          }
          if (state.status == Status.success && state.data != null) {
            final data = state.data!;
            return AppScaffold(
              appBar: AppBar(title: const Text('Trading Dashboard')),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Total value & gain/loss
                      AppCard(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Total Inventory Value',
                                      style: AppTypography.subtitle2.copyWith(
                                          color: AppColorsDS.textSecondary)),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${data.totalValue.toStringAsFixed(0)}',
                                    style: AppTypography.h2,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Gain/Loss',
                                    style: AppTypography.subtitle2.copyWith(
                                        color: AppColorsDS.textSecondary)),
                                const SizedBox(height: 4),
                                Text(
                                  (data.gainLoss >= 0 ? '+' : '-') +
                                      '\$${data.gainLoss.abs().toStringAsFixed(0)}',
                                  style: AppTypography.h3.copyWith(
                                    color: data.gainLoss >= 0
                                        ? AppColorsDS.success
                                        : AppColorsDS.danger,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SectionSpacing(),
                      // Quick action
                      PrimaryButton(
                        label: 'New Trade',
                        onPressed: () {
                          Navigator.of(context).pushNamed(Routes.tradeBuilder);
                        },
                      ),
                      const SectionSpacing(),
                      // Trending items
                      Text('Trending Items', style: AppTypography.h3),
                      const SizedBox(height: AppSpacing.sm),
                      SizedBox(
                        height: 240,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.trending.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: AppSpacing.md),
                          itemBuilder: (_, index) {
                            final item = data.trending[index];
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
                      const SectionSpacing(),
                      // Alerts
                      if (data.alerts.isNotEmpty) ...[
                        Text('Alerts', style: AppTypography.h3),
                        const SizedBox(height: AppSpacing.sm),
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (final alert in data.alerts)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.notification_important,
                                          color: AppColorsDS.warning, size: 20),
                                      const SizedBox(width: AppSpacing.sm),
                                      Expanded(
                                          child: Text(alert,
                                              style: AppTypography.body2)),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SectionSpacing(),
                      ],
                      // Recent trades
                      Text('Recent Trades', style: AppTypography.h3),
                      const SizedBox(height: AppSpacing.sm),
                      if (data.recentTrades.isEmpty)
                        const EmptyWidget(message: 'No recent trades')
                      else
                        Column(
                          children: [
                            for (final trade in data.recentTrades) ...[
                              TradeSummaryCard(trade: trade),
                              const SizedBox(height: AppSpacing.md),
                            ],
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            );
          }
          // Default fallback
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
