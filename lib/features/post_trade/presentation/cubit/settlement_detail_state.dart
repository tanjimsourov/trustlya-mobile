import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/settlement_instruction.dart';

/// State for the settlement detail page. Holds the loaded
/// instruction or an error state if not found.
class SettlementDetailState extends BaseState<SettlementInstruction?> {
  const SettlementDetailState(
      {super.status = Status.initial, super.data, super.message});

  SettlementDetailState copyWith(
      {Status? status, SettlementInstruction? data, String? message}) {
    return SettlementDetailState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
