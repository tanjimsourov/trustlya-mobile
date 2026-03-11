import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/treasury_position.dart';

/// State for the treasury positioning page. Holds a list of
/// positions across different accounts and currencies.
class TreasuryPositionState extends BaseState<List<TreasuryPosition>?> {
  const TreasuryPositionState(
      {super.status = Status.initial, super.data, super.message});

  TreasuryPositionState copyWith(
      {Status? status, List<TreasuryPosition>? data, String? message}) {
    return TreasuryPositionState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
