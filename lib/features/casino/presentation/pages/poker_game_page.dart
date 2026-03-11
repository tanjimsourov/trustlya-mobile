import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../presentation/cubit/casino_cubit.dart';
import '../../presentation/cubit/casino_state.dart';
import '../../domain/entities/game_history_item.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

/// Simulated poker game page.
class PokerGamePage extends StatelessWidget {
  const PokerGamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CasinoCubit>(
      create: (_) => getIt<CasinoCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Poker Game')),
        body: BlocBuilder<CasinoCubit, CasinoState>(
          builder: (context, state) {
            switch (state.status) {
              case Status.loading:
                return const LoadingWidget();
              case Status.error:
                return shared.ErrorWidgetView(message: state.message);
              case Status.success:
                final result = state.data as GameHistoryItem;
                return Center(
                  child: Text(
                    'Result: ${result.result.toUpperCase()}\nBet: ${result.betAmount}\nPayout: ${result.payout}',
                  ),
                );
              default:
                return Center(
                  child: ElevatedButton(
                    onPressed: () => context.read<CasinoCubit>().playPoker(),
                    child: const Text('Play Poker'),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
