import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/impact_analytics.dart';

/// State representing environmental impact analytics.
class ImpactAnalyticsState extends BaseState<ImpactAnalytics?> {
  const ImpactAnalyticsState(
      {super.status = Status.initial, super.data, super.message});

  ImpactAnalyticsState copyWith(
      {Status? status, ImpactAnalytics? data, String? message}) {
    return ImpactAnalyticsState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
