import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/cubit/base_state.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/sla_metric.dart';
import '../../domain/repositories/post_trade_repository.dart';
import 'operations_sla_state.dart';

/// Cubit responsible for loading SLA metrics. It wraps the
/// repository call and maps the result into UI friendly states.
class OperationsSlaCubit extends Cubit<OperationsSlaState> {
  final PostTradeRepository _repository;
  OperationsSlaCubit(this._repository) : super(const OperationsSlaState());

  Future<void> loadSla() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.fetchSlaMetrics();
    if (result is Success<List<SlaMetric>>) {
      final list = result.value;
      if (list.isEmpty) {
        emit(state.copyWith(status: Status.empty, data: []));
      } else {
        emit(state.copyWith(status: Status.success, data: list));
      }
    } else if (result is Error<List<SlaMetric>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
