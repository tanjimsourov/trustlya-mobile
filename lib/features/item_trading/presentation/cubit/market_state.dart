import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/item.dart';

/// State for the market page. Holds a list of items available on the
/// market. Extends [BaseState] to reuse status, data and message.
class MarketState extends BaseState<List<Item>> {
  const MarketState(
      {Status status = Status.initial, List<Item>? data, String? message})
      : super(status: status, data: data, message: message);

  MarketState copyWith({Status? status, List<Item>? data, String? message}) {
    return MarketState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
