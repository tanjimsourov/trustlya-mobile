import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/carbon_holding.dart';

/// State for the carbon holdings page showing all active and retired
/// credit positions.
class HoldingsState extends BaseState<List<CarbonHolding>?> {
  const HoldingsState(
      {super.status = Status.initial, super.data, super.message});

  HoldingsState copyWith(
      {Status? status, List<CarbonHolding>? data, String? message}) {
    return HoldingsState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
