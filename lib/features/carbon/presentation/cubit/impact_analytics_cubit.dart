import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/impact_analytics.dart';
import '../../domain/repositories/carbon_repository.dart';
import 'impact_analytics_state.dart';

/// Cubit that loads the user’s carbon impact analytics.
class ImpactAnalyticsCubit extends Cubit<ImpactAnalyticsState> {
  final CarbonRepository _repository;
  ImpactAnalyticsCubit(this._repository) : super(const ImpactAnalyticsState());

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getImpactAnalytics();
    if (result is Success<ImpactAnalytics>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<ImpactAnalytics>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
