import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/segmented_control.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../cubit/trade_history_cubit.dart';
import '../cubit/trade_history_state.dart';
import '../widgets/trade_summary_card.dart';

/// Displays the user's past trades segmented by status. Allows
/// switching between All, Pending, Completed and Cancelled tabs via a
/// segmented control. Uses [TradeHistoryCubit] to load the history
/// from the repository.
class TradeHistoryPage extends StatefulWidget {
  const TradeHistoryPage({Key? key}) : super(key: key);

  @override
  State<TradeHistoryPage> createState() => _TradeHistoryPageState();
}

class _TradeHistoryPageState extends State<TradeHistoryPage> {
  String _statusFilter = 'all';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TradeHistoryCubit>().loadHistory());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TradeHistoryCubit>(
      create: (_) => getIt<TradeHistoryCubit>(),
      child: BlocBuilder<TradeHistoryCubit, TradeHistoryState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const LoadingWidget();
          }
          if (state.status == Status.error) {
            return shared.ErrorWidgetView(message: state.message);
          }
          final trades = state.data ?? [];
          // Filter trades according to the selected status
          final filteredTrades = trades.where((trade) {
            if (_statusFilter == 'all') return true;
            return trade.status.toLowerCase() == _statusFilter;
          }).toList();
          return AppScaffold(
            appBar: AppBar(title: const Text('Trade History')),
            body: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SegmentedControl<String>(
                    values: const ['all', 'pending', 'completed', 'cancelled'],
                    selected: _statusFilter,
                    onChanged: (val) {
                      setState(() {
                        _statusFilter = val;
                      });
                    },
                    labels: const [
                      Text('All'),
                      Text('Pending'),
                      Text('Completed'),
                      Text('Cancelled'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (filteredTrades.isEmpty)
                    const Expanded(
                      child: EmptyWidget(message: 'No trades found'),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: filteredTrades.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (_, index) {
                          return TradeSummaryCard(trade: filteredTrades[index]);
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
