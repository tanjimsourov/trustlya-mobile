import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/carbon_holding.dart';
import '../../domain/entities/carbon_transaction.dart';
import '../../domain/repositories/carbon_repository.dart';
import 'retire_credits_state.dart';

/// Cubit to handle the retirement of carbon credits. Loads current
/// holdings and performs retirement transactions. The state holds
/// either the list of holdings or the resulting [CarbonTransaction].
class RetireCreditsCubit extends Cubit<RetireCreditsState> {
  final CarbonRepository _repository;
  RetireCreditsCubit(this._repository) : super(const RetireCreditsState());

  Future<void> loadHoldings() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getHoldings();
    if (result is Success<List<CarbonHolding>>) {
      emit(state.copyWith(
          status: result.value.isEmpty ? Status.empty : Status.success,
          data: result.value));
    } else if (result is Error<List<CarbonHolding>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> retire(String projectId, double quantity,
      {String? reason}) async {
    emit(state.copyWith(status: Status.loading));
    final result =
        await _repository.retireCredits(projectId, quantity, reason: reason);
    if (result is Success<CarbonTransaction>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<CarbonTransaction>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
