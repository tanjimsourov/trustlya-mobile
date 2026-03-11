import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/dashboard_data.dart';

/// State for the trading dashboard. Extends [BaseState] with
/// [ItemTradingDashboardData] as the payload.
class TradingDashboardState extends BaseState<ItemTradingDashboardData> {
  const TradingDashboardState(
      {Status status = Status.initial,
      ItemTradingDashboardData? data,
      String? message})
      : super(status: status, data: data, message: message);

  TradingDashboardState copyWith(
      {Status? status, ItemTradingDashboardData? data, String? message}) {
    return TradingDashboardState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
