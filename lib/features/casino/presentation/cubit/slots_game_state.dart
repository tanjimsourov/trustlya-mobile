import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/bet_history.dart';

/// State for the slots game page. Holds the last bet result when
/// the user plays a spin. The [data] property is a [BetHistoryItem]
/// representing the outcome of the most recent spin.
class SlotsGameState extends BaseState<BetHistoryItem?> {
  const SlotsGameState(
      {Status status = Status.initial, BetHistoryItem? data, String? message})
      : super(status: status, data: data, message: message);

  SlotsGameState copyWith(
      {Status? status, BetHistoryItem? data, String? message}) {
    return SlotsGameState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
