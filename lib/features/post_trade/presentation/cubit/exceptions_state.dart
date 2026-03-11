import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/settlement_exception.dart';

/// State for the exceptions and breaks page. Holds a list of
/// settlement exceptions along with severity information.
class ExceptionsState extends BaseState<List<SettlementException>?> {
  const ExceptionsState(
      {super.status = Status.initial, super.data, super.message});

  ExceptionsState copyWith(
      {Status? status, List<SettlementException>? data, String? message}) {
    return ExceptionsState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
