import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import 'swap_data.dart';

/// State for the swap/convert page. Holds a [SwapData] with current
/// selections and calculations.
class SwapState extends BaseState<SwapData?> {
  const SwapState(
      {Status status = Status.initial, SwapData? data, String? message})
      : super(status: status, data: data, message: message);

  SwapState copyWith({Status? status, SwapData? data, String? message}) {
    return SwapState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
