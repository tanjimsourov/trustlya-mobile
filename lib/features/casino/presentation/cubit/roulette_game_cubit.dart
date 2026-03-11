import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/bet_history.dart';
import '../../domain/repositories/casino_repository.dart';
import 'roulette_game_state.dart';

/// Cubit managing roulette spins. Accepts a bet amount and calls the
/// repository to simulate a roulette game. Emits the resulting
/// [BetHistoryItem] or error.
class RouletteGameCubit extends Cubit<RouletteGameState> {
  final CasinoRepository _repository;
  RouletteGameCubit(this._repository) : super(const RouletteGameState());

  Future<void> play(double bet) async {
    emit(state.copyWith(status: Status.loading));
    final res = await _repository.playRoulette(bet);
    if (res is Success<BetHistoryItem>) {
      emit(state.copyWith(status: Status.success, data: res.value));
    } else if (res is Error<BetHistoryItem>) {
      emit(state.copyWith(status: Status.error, message: res.message));
    }
  }
}
