import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/issuance_metric.dart';

/// State for the issuance analytics page, holding a list of metrics
/// describing the programmeâ€™s performance.
class IssuanceAnalyticsState extends BaseState<List<IssuanceMetric>?> {
  const IssuanceAnalyticsState(
      {super.status = Status.initial, super.data, super.message});

  IssuanceAnalyticsState copyWith(
      {Status? status, List<IssuanceMetric>? data, String? message}) {
    return IssuanceAnalyticsState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
