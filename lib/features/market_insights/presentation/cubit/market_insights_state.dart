import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/market_insights_data.dart';

/// State for the market insights page. Holds a [MarketInsightsData]
/// payload and uses the [BaseState] statuses for loading and
/// error handling.
class MarketInsightsState extends BaseState<MarketInsightsData> {
  const MarketInsightsState({required super.status, super.data, super.message});

  MarketInsightsState copyWith({
    Status? status,
    MarketInsightsData? data,
    String? message,
  }) {
    return MarketInsightsState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
