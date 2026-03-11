import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/trade.dart';
import '../../domain/repositories/item_trading_repository.dart';
import 'trade_history_state.dart';

/// Cubit for loading the user’s trade history. Provides separate
/// statuses for pending, completed and cancelled trades via a single
/// list with status metadata contained in [Trade.status].
class TradeHistoryCubit extends Cubit<TradeHistoryState> {
  final ItemTradingRepository _repository;
  TradeHistoryCubit(this._repository) : super(const TradeHistoryState());

  Future<void> loadHistory() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getTradeHistory();
    if (result is Success<List<Trade>>) {
      if (result.value.isEmpty) {
        emit(state.copyWith(status: Status.empty, data: []));
      } else {
        emit(state.copyWith(status: Status.success, data: result.value));
      }
    } else if (result is Error<List<Trade>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
