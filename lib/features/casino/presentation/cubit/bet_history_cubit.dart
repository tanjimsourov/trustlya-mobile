import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/bet_history.dart';
import '../../domain/repositories/casino_repository.dart';

/// State for the betting history page. Holds a list of [BetHistoryItem]
/// representing the user’s past bets. Filtering can be applied at
/// the UI level using simple predicates on [BetHistoryItem.gameType] or
/// [BetHistoryItem.result].
class BetHistoryState extends BaseState<List<BetHistoryItem>?> {
  const BetHistoryState(
      {Status status = Status.initial,
      List<BetHistoryItem>? data,
      String? message})
      : super(status: status, data: data, message: message);

  BetHistoryState copyWith(
      {Status? status, List<BetHistoryItem>? data, String? message}) {
    return BetHistoryState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}

/// Cubit to load the user’s betting history from the repository.
class BetHistoryCubit extends Cubit<BetHistoryState> {
  final CasinoRepository _repository;
  BetHistoryCubit(this._repository) : super(const BetHistoryState());

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading));
    final res = await _repository.getBetHistory();
    if (res is Success<List<BetHistoryItem>>) {
      final list = res.value;
      emit(state.copyWith(
          status: list.isEmpty ? Status.empty : Status.success, data: list));
    } else if (res is Error<List<BetHistoryItem>>) {
      emit(state.copyWith(status: Status.error, message: res.message));
    }
  }
}
