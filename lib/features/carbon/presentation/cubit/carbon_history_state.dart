import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/carbon_transaction.dart';

/// State for carbon credit transaction history.
class CarbonHistoryState extends BaseState<List<CarbonTransaction>?> {
  const CarbonHistoryState(
      {super.status = Status.initial, super.data, super.message});

  CarbonHistoryState copyWith(
      {Status? status, List<CarbonTransaction>? data, String? message}) {
    return CarbonHistoryState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
