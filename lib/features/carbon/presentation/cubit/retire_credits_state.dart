import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/carbon_holding.dart';
import '../../domain/entities/carbon_transaction.dart';

/// State for retiring carbon credits. Contains either a list of
/// holdings to choose from or the resulting transaction when the
/// retirement is completed.
class RetireCreditsState extends BaseState<dynamic> {
  const RetireCreditsState(
      {super.status = Status.initial, super.data, super.message});

  RetireCreditsState copyWith({Status? status, dynamic data, String? message}) {
    return RetireCreditsState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
