import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/bet_history.dart';
import '../../domain/repositories/casino_repository.dart';
import 'slots_game_state.dart';

/// Cubit managing the state of the slots game. It allows the user
/// to place a bet and spin the reels, returning a [BetHistoryItem]
/// representing the outcome.
class SlotsGameCubit extends Cubit<SlotsGameState> {
  final CasinoRepository _repository;
  SlotsGameCubit(this._repository) : super(const SlotsGameState());

  /// Plays a slots game with the provided [bet] amount. Emits loading
  /// before calling the repository, and success/error based on the result.
  Future<void> play(double bet) async {
    emit(state.copyWith(status: Status.loading));
    final res = await _repository.playSlots(bet);
    if (res is Success<BetHistoryItem>) {
      emit(state.copyWith(status: Status.success, data: res.value));
    } else if (res is Error<BetHistoryItem>) {
      emit(state.copyWith(status: Status.error, message: res.message));
    }
  }
}
