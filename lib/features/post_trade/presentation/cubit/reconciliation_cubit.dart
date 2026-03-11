import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/cubit/base_state.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/reconciliation_break.dart';
import '../../domain/repositories/post_trade_repository.dart';
import 'reconciliation_state.dart';

/// Cubit managing the state of reconciliation breaks. It loads
/// breaks from the repository and handles loading/empty/error states.
class ReconciliationCubit extends Cubit<ReconciliationState> {
  final PostTradeRepository _repository;
  ReconciliationCubit(this._repository) : super(const ReconciliationState());

  Future<void> loadBreaks() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.fetchReconciliationCenter();
    if (result is Success<List<ReconciliationBreak>>) {
      final list = result.value;
      if (list.isEmpty) {
        emit(state.copyWith(status: Status.empty, data: []));
      } else {
        emit(state.copyWith(status: Status.success, data: list));
      }
    } else if (result is Error<List<ReconciliationBreak>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
