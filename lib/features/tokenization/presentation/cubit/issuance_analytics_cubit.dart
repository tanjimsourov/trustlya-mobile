import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/issuance_metric.dart';
import '../../domain/repositories/tokenization_repository.dart';
import '../../../../core/utils/result.dart';
import 'issuance_analytics_state.dart';

/// Cubit for loading issuance analytics for a programme.
class IssuanceAnalyticsCubit extends Cubit<IssuanceAnalyticsState> {
  final TokenizationRepository _repository;
  IssuanceAnalyticsCubit(this._repository)
      : super(const IssuanceAnalyticsState());

  /// Loads analytics metrics for the specified programme. Emits the
  /// appropriate [Status] based on the result of the repository call.
  Future<void> loadAnalytics(String programId) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.fetchIssuanceAnalytics(programId);
    if (result is Success<List<IssuanceMetric>>) {
      final metrics = result.value;
      emit(state.copyWith(
          status: metrics.isEmpty ? Status.empty : Status.success,
          data: metrics));
    } else if (result is Error<List<IssuanceMetric>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
