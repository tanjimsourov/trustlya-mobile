import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/lobby_data.dart';
import '../../domain/repositories/casino_repository.dart';
import 'casino_lobby_state.dart';

/// Cubit responsible for loading the casino lobby data. It fetches
/// categories, featured games, promotions, winners and recommendations
/// from the [CasinoRepository].
class CasinoLobbyCubit extends Cubit<CasinoLobbyState> {
  final CasinoRepository _repository;
  CasinoLobbyCubit(this._repository) : super(const CasinoLobbyState());

  /// Loads lobby data and updates state accordingly.
  Future<void> load() async {
    emit(state.copyWith(status: Status.loading));
    final res = await _repository.getLobbyData();
    if (res is Success<CasinoLobbyData>) {
      final data = res.value;
      emit(state.copyWith(
          status: data == null ? Status.empty : Status.success, data: data));
    } else if (res is Error<CasinoLobbyData>) {
      emit(state.copyWith(status: Status.error, message: res.message));
    }
  }
}
