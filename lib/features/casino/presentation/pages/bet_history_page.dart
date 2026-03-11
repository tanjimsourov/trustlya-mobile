import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/bet_history.dart';
import '../../presentation/cubit/bet_history_cubit.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/segmented_control.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Displays the user's casino betting history. Supports filtering by
/// game type or result via a segmented control. Each entry shows
/// bet amount, payout, game and timestamp.
class BetHistoryPage extends StatefulWidget {
  const BetHistoryPage({Key? key}) : super(key: key);

  @override
  State<BetHistoryPage> createState() => _BetHistoryPageState();
}

class _BetHistoryPageState extends State<BetHistoryPage> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BetHistoryCubit, BetHistoryState>(
      builder: (context, state) {
        switch (state.status) {
          case Status.loading:
            return const LoadingWidget();
          case Status.error:
            return shared.ErrorWidgetView(message: state.message);
          case Status.empty:
            return const EmptyWidget();
          case Status.success:
            var items = state.data ?? [];
            // Filter items
            if (_filter == 'Wins') {
              items = items.where((e) => e.payout > 0).toList();
            } else if (_filter == 'Losses') {
              items = items.where((e) => e.payout <= 0).toList();
            } else if (_filter == 'Slots' ||
                _filter == 'Roulette' ||
                _filter == 'Blackjack') {
              items = items
                  .where(
                      (e) => e.gameType.toLowerCase() == _filter.toLowerCase())
                  .toList();
            }
            return AppScaffold(
              appBar: AppBar(
                title: const Text('Betting History'),
                backgroundColor: AppColorsDS.surface,
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: SegmentedControl<String>(
                      values: const [
                        'All',
                        'Slots',
                        'Roulette',
                        'Blackjack',
                        'Wins',
                        'Losses'
                      ],
                      labels: const [
                        Text('All'),
                        Text('Slots'),
                        Text('Roulette'),
                        Text('Blackjack'),
                        Text('Wins'),
                        Text('Losses'),
                      ],
                      selected: _filter,
                      onChanged: (val) {
                        setState(() {
                          _filter = val;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _buildHistoryRow(item);
                      },
                    ),
                  ),
                ],
              ),
            );
          default:
            return const LoadingWidget();
        }
      },
    );
  }

  Widget _buildHistoryRow(BetHistoryItem item) {
    final isWin = item.payout > 0;
    final payout = item.payout;
    return ListTile(
      leading: Icon(
        _iconForGame(item.gameType),
        color: AppColorsDS.primary,
      ),
      title: Text(
        item.gameName,
        style: AppTypography.subtitle1.copyWith(color: AppColorsDS.textPrimary),
      ),
      subtitle: Text(
        'Bet: \$${item.betAmount.toStringAsFixed(2)} • ${item.date.toLocal().toString().split('.').first}',
        style: AppTypography.caption.copyWith(color: AppColorsDS.textSecondary),
      ),
      trailing: Text(
        isWin
            ? '+\$${payout.toStringAsFixed(2)}'
            : '-\$${(-payout).toStringAsFixed(2)}',
        style: AppTypography.subtitle2
            .copyWith(color: isWin ? AppColorsDS.success : AppColorsDS.danger),
      ),
    );
  }

  IconData _iconForGame(String type) {
    switch (type.toLowerCase()) {
      case 'slots':
        return Icons.casino;
      case 'roulette':
        return Icons.sports;
      case 'blackjack':
        return Icons.style;
      default:
        return Icons.casino;
    }
  }
}
