import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import 'deposit_data.dart';

/// State for the deposit page. Holds a [DepositData] object with the
/// selected asset, networks and generated address.
class DepositState extends BaseState<DepositData?> {
  const DepositState(
      {Status status = Status.initial, DepositData? data, String? message})
      : super(status: status, data: data, message: message);

  DepositState copyWith({Status? status, DepositData? data, String? message}) {
    return DepositState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
