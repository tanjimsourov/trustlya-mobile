import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/game.dart';
import '../../domain/entities/game_history_item.dart';
import '../../domain/repositories/casino_repository.dart';
import 'casino_state.dart';

/// Cubit for casino operations.
class CasinoCubit extends Cubit<CasinoState> {
  final CasinoRepository _repository;
  CasinoCubit(this._repository) : super(const CasinoState());

  Future<void> loadLobby() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getLobbyGames();
    if (result is Success<List<Game>>) {
      final games = result.value;
      emit(state.copyWith(
          status: games.isEmpty ? Status.empty : Status.success, data: games));
    } else if (result is Error<List<Game>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> playSlots() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.playSlots();
    if (result is Success<GameHistoryItem>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<GameHistoryItem>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> playPoker() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.playPoker();
    if (result is Success<GameHistoryItem>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<GameHistoryItem>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> loadHistory() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getHistory();
    if (result is Success<List<GameHistoryItem>>) {
      final history = result.value;
      emit(state.copyWith(
          status: history.isEmpty ? Status.empty : Status.success,
          data: history));
    } else if (result is Error<List<GameHistoryItem>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
