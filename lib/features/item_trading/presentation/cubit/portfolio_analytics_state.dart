import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/portfolio_analytics.dart';

/// State for the portfolio analytics page. Holds a [PortfolioAnalytics]
/// object containing performance and distribution data.
class PortfolioAnalyticsState extends BaseState<PortfolioAnalytics> {
  const PortfolioAnalyticsState(
      {Status status = Status.initial,
      PortfolioAnalytics? data,
      String? message})
      : super(status: status, data: data, message: message);

  PortfolioAnalyticsState copyWith(
      {Status? status, PortfolioAnalytics? data, String? message}) {
    return PortfolioAnalyticsState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
