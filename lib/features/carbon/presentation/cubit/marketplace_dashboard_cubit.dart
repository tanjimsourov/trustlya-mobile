import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/marketplace_dashboard_data.dart';
import '../../domain/repositories/carbon_repository.dart';
import 'marketplace_dashboard_state.dart';

/// Cubit responsible for loading the marketplace dashboard data. It
/// aggregates information about the user’s total credits, impact and
/// featured projects.
class MarketplaceDashboardCubit extends Cubit<MarketplaceDashboardState> {
  final CarbonRepository _repository;
  MarketplaceDashboardCubit(this._repository)
      : super(const MarketplaceDashboardState());

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getDashboardData();
    if (result is Success<MarketplaceDashboardData>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<MarketplaceDashboardData>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
