import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/settlement_instruction.dart';
import '../../domain/repositories/post_trade_repository.dart';
import '../../../../core/utils/result.dart';
import 'settlement_queue_state.dart';

/// Cubit managing the state of the settlement queue. Responsible
/// for loading the list of settlement instructions awaiting
/// processing or recently completed.
class SettlementQueueCubit extends Cubit<SettlementQueueState> {
  final PostTradeRepository _repository;
  SettlementQueueCubit(this._repository) : super(const SettlementQueueState());

  /// Loads all settlement instructions from the repository and
  /// updates the state accordingly.
  Future<void> loadQueue() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.fetchSettlementQueue();
    if (result is Success<List<SettlementInstruction>>) {
      final list = result.value;
      if (list.isEmpty) {
        emit(state.copyWith(status: Status.empty, data: []));
      } else {
        emit(state.copyWith(status: Status.success, data: list));
      }
    } else if (result is Error<List<SettlementInstruction>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
