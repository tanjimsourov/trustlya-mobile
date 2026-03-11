import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/sla_metric.dart';

/// State for the operations SLA and monitoring page. Holds a list of
/// SLA metrics representing operational performance.
class OperationsSlaState extends BaseState<List<SlaMetric>?> {
  const OperationsSlaState(
      {super.status = Status.initial, super.data, super.message});

  OperationsSlaState copyWith(
      {Status? status, List<SlaMetric>? data, String? message}) {
    return OperationsSlaState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
