import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../domain/entities/game_history_item.dart';
import '../../presentation/cubit/casino_cubit.dart';
import '../../presentation/cubit/casino_state.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

/// Displays casino game history.
class CasinoHistoryPage extends StatelessWidget {
  const CasinoHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CasinoCubit>(
      create: (_) => getIt<CasinoCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Casino History')),
        body: BlocBuilder<CasinoCubit, CasinoState>(
          builder: (context, state) {
            switch (state.status) {
              case Status.loading:
                return const LoadingWidget();
              case Status.empty:
                return const EmptyWidget();
              case Status.error:
                return shared.ErrorWidgetView(message: state.message);
              case Status.success:
                final history = state.data as List<GameHistoryItem>;
                return ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];
                    return ListTile(
                      title: Text(
                          '${item.gameName} (${item.result.toUpperCase()})'),
                      subtitle: Text('Bet: ${item.betAmount}'),
                      trailing: Text('${item.date.toLocal()}'),
                    );
                  },
                );
              default:
                return Center(
                  child: ElevatedButton(
                    onPressed: () => context.read<CasinoCubit>().loadHistory(),
                    child: const Text('Load History'),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
