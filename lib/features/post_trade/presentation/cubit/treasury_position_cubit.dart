import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/cubit/base_state.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/treasury_position.dart';
import '../../domain/repositories/post_trade_repository.dart';
import 'treasury_position_state.dart';

/// Cubit responsible for loading treasury positions. Emits loading,
/// success, empty or error based on repository responses.
class TreasuryPositionCubit extends Cubit<TreasuryPositionState> {
  final PostTradeRepository _repository;
  TreasuryPositionCubit(this._repository)
      : super(const TreasuryPositionState());

  Future<void> loadPositions() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.fetchTreasuryPositions();
    if (result is Success<List<TreasuryPosition>>) {
      final list = result.value;
      if (list.isEmpty) {
        emit(state.copyWith(status: Status.empty, data: []));
      } else {
        emit(state.copyWith(status: Status.success, data: list));
      }
    } else if (result is Error<List<TreasuryPosition>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
