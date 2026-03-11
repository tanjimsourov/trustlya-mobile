import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';

/// State for trading feature.
class TradingState extends BaseState<dynamic> {
  const TradingState(
      {super.status = Status.initial, super.data, super.message});

  TradingState copyWith({Status? status, dynamic data, String? message}) {
    return TradingState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
