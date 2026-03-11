import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/compliance_checkpoint.dart';

/// State for the compliance readiness page. Contains checkpoints that
/// must be passed for a programme to proceed.
class ComplianceReadinessState extends BaseState<List<ComplianceCheckpoint>?> {
  const ComplianceReadinessState(
      {super.status = Status.initial, super.data, super.message});

  ComplianceReadinessState copyWith(
      {Status? status, List<ComplianceCheckpoint>? data, String? message}) {
    return ComplianceReadinessState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
