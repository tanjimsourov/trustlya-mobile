import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/cubit/base_state.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/counterparty_exposure.dart';
import '../../domain/repositories/post_trade_repository.dart';
import 'counterparty_exposure_state.dart';

/// Cubit for loading counterparty exposure data. Exposes a
/// [loadExposure] method that retrieves the list from the repository.
class CounterpartyExposureCubit extends Cubit<CounterpartyExposureState> {
  final PostTradeRepository _repository;
  CounterpartyExposureCubit(this._repository)
      : super(const CounterpartyExposureState());

  Future<void> loadExposure() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.fetchCounterpartyExposure();
    if (result is Success<List<CounterpartyExposure>>) {
      final list = result.value;
      if (list.isEmpty) {
        emit(state.copyWith(status: Status.empty, data: []));
      } else {
        emit(state.copyWith(status: Status.success, data: list));
      }
    } else if (result is Error<List<CounterpartyExposure>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
