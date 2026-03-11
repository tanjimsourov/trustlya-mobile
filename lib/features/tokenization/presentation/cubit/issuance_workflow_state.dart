import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/issuance_stage.dart';

/// State for the issuance workflow page. Holds the series of stages
/// associated with a specific programme.
class IssuanceWorkflowState extends BaseState<List<IssuanceStage>?> {
  const IssuanceWorkflowState(
      {super.status = Status.initial, super.data, super.message});

  IssuanceWorkflowState copyWith(
      {Status? status, List<IssuanceStage>? data, String? message}) {
    return IssuanceWorkflowState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
