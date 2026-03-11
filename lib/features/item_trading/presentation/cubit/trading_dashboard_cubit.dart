import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/repositories/item_trading_repository.dart';
import 'trading_dashboard_state.dart';

/// Cubit responsible for loading and exposing dashboard data for
/// game item trading. It fetches a summary of the user’s inventory
/// value, gain/loss, trending items, alerts and recent trades.
class TradingDashboardCubit extends Cubit<TradingDashboardState> {
  final ItemTradingRepository _repository;
  TradingDashboardCubit(this._repository)
      : super(const TradingDashboardState());

  Future<void> loadDashboard() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getDashboardData();
    if (result is Success<ItemTradingDashboardData>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<ItemTradingDashboardData>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
