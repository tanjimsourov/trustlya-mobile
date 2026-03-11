import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/game_detail.dart';
import '../../domain/repositories/casino_repository.dart';
import 'game_detail_state.dart';

/// Cubit responsible for loading a single casino game detail. It fetches
/// metadata such as RTP, min/max bet and description from the repository.
class GameDetailCubit extends Cubit<GameDetailState> {
  final CasinoRepository _repository;
  GameDetailCubit(this._repository) : super(const GameDetailState());

  /// Loads detail information for the game identified by [id].
  Future<void> load(String id) async {
    emit(state.copyWith(status: Status.loading));
    final res = await _repository.getGameDetail(id);
    if (res is Success<GameDetail>) {
      emit(state.copyWith(status: Status.success, data: res.value));
    } else if (res is Error<GameDetail>) {
      emit(state.copyWith(status: Status.error, message: res.message));
    }
  }
}
