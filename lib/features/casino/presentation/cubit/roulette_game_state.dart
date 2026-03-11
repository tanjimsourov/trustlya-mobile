import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/bet_history.dart';

/// State for the roulette game page. Holds the result of the last spin.
class RouletteGameState extends BaseState<BetHistoryItem?> {
  const RouletteGameState(
      {Status status = Status.initial, BetHistoryItem? data, String? message})
      : super(status: status, data: data, message: message);

  RouletteGameState copyWith(
      {Status? status, BetHistoryItem? data, String? message}) {
    return RouletteGameState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
