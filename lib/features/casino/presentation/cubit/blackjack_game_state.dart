import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/bet_history.dart';

/// State for the blackjack game page. Holds the last bet result.
class BlackjackGameState extends BaseState<BetHistoryItem?> {
  const BlackjackGameState(
      {Status status = Status.initial, BetHistoryItem? data, String? message})
      : super(status: status, data: data, message: message);

  BlackjackGameState copyWith(
      {Status? status, BetHistoryItem? data, String? message}) {
    return BlackjackGameState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
