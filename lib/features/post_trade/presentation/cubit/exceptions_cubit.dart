import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/cubit/base_state.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/settlement_exception.dart';
import '../../domain/repositories/post_trade_repository.dart';
import 'exceptions_state.dart';

/// Cubit managing settlement exceptions. Provides functionality to
/// load the list of exceptions from the repository.
class ExceptionsCubit extends Cubit<ExceptionsState> {
  final PostTradeRepository _repository;
  ExceptionsCubit(this._repository) : super(const ExceptionsState());

  Future<void> loadExceptions() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.fetchExceptions();
    if (result is Success<List<SettlementException>>) {
      final list = result.value;
      if (list.isEmpty) {
        emit(state.copyWith(status: Status.empty, data: []));
      } else {
        emit(state.copyWith(status: Status.success, data: list));
      }
    } else if (result is Error<List<SettlementException>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
