import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/trade.dart';

/// State for the trade history page. Holds a list of past trades.
class TradeHistoryState extends BaseState<List<Trade>> {
  const TradeHistoryState(
      {Status status = Status.initial, List<Trade>? data, String? message})
      : super(status: status, data: data, message: message);

  TradeHistoryState copyWith(
      {Status? status, List<Trade>? data, String? message}) {
    return TradeHistoryState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
