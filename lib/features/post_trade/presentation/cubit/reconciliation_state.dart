import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/reconciliation_break.dart';

/// State for the reconciliation centre page. Holds a list of
/// reconciliation breaks discovered during matching.
class ReconciliationState extends BaseState<List<ReconciliationBreak>?> {
  const ReconciliationState(
      {super.status = Status.initial, super.data, super.message});

  ReconciliationState copyWith(
      {Status? status, List<ReconciliationBreak>? data, String? message}) {
    return ReconciliationState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
