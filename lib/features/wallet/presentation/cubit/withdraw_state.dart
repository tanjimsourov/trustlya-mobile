import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import 'withdraw_data.dart';

/// State for the withdraw page. Holds a [WithdrawData] with the
/// currently selected values. Uses [BaseState] for status, data and
/// error handling.
class WithdrawState extends BaseState<WithdrawData?> {
  const WithdrawState(
      {Status status = Status.initial, WithdrawData? data, String? message})
      : super(status: status, data: data, message: message);

  WithdrawState copyWith(
      {Status? status, WithdrawData? data, String? message}) {
    return WithdrawState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
