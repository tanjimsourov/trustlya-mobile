import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/carbon_transaction.dart';
import '../../domain/repositories/carbon_repository.dart';
import 'carbon_history_state.dart';

/// Cubit responsible for loading and filtering carbon transaction history.
class CarbonHistoryCubit extends Cubit<CarbonHistoryState> {
  final CarbonRepository _repository;
  CarbonHistoryCubit(this._repository) : super(const CarbonHistoryState());

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getTransactionHistory();
    if (result is Success<List<CarbonTransaction>>) {
      final list = result.value;
      emit(state.copyWith(
          status: list.isEmpty ? Status.empty : Status.success, data: list));
    } else if (result is Error<List<CarbonTransaction>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
