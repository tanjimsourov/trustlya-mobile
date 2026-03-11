import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/settlement_instruction.dart';

/// State for the settlement queue page. Holds a list of instructions
/// currently in the postâ€‘trade queue.
class SettlementQueueState extends BaseState<List<SettlementInstruction>?> {
  const SettlementQueueState(
      {super.status = Status.initial, super.data, super.message});

  SettlementQueueState copyWith(
      {Status? status, List<SettlementInstruction>? data, String? message}) {
    return SettlementQueueState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
