import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/marketplace_dashboard_data.dart';

/// State for the marketplace dashboard page. Holds [MarketplaceDashboardData]
/// and status information.
class MarketplaceDashboardState extends BaseState<MarketplaceDashboardData?> {
  const MarketplaceDashboardState(
      {super.status = Status.initial, super.data, super.message});

  MarketplaceDashboardState copyWith(
      {Status? status, MarketplaceDashboardData? data, String? message}) {
    return MarketplaceDashboardState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
