import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/carbon_holding.dart';
import '../../domain/repositories/carbon_repository.dart';
import 'holdings_state.dart';

/// Cubit that loads the user’s carbon credit holdings. It simply
/// requests the list from the repository and emits loading, empty,
/// success or error states.
class HoldingsCubit extends Cubit<HoldingsState> {
  final CarbonRepository _repository;
  HoldingsCubit(this._repository) : super(const HoldingsState());

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getHoldings();
    if (result is Success<List<CarbonHolding>>) {
      final list = result.value;
      emit(state.copyWith(
          status: list.isEmpty ? Status.empty : Status.success, data: list));
    } else if (result is Error<List<CarbonHolding>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
