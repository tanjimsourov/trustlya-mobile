import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/game_detail.dart';

/// State for the game detail page. Holds a [GameDetail] object when
/// loaded successfully.
class GameDetailState extends BaseState<GameDetail?> {
  const GameDetailState(
      {Status status = Status.initial, GameDetail? data, String? message})
      : super(status: status, data: data, message: message);

  GameDetailState copyWith(
      {Status? status, GameDetail? data, String? message}) {
    return GameDetailState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
