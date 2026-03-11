import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/bet_history.dart';
import '../../domain/repositories/casino_repository.dart';
import 'blackjack_game_state.dart';

/// Cubit responsible for blackjack game logic. It calls the
/// repository to simulate a blackjack hand when the user places a bet.
class BlackjackGameCubit extends Cubit<BlackjackGameState> {
  final CasinoRepository _repository;
  BlackjackGameCubit(this._repository) : super(const BlackjackGameState());

  Future<void> play(double bet) async {
    emit(state.copyWith(status: Status.loading));
    final res = await _repository.playBlackjack(bet);
    if (res is Success<BetHistoryItem>) {
      emit(state.copyWith(status: Status.success, data: res.value));
    } else if (res is Error<BetHistoryItem>) {
      emit(state.copyWith(status: Status.error, message: res.message));
    }
  }
}
