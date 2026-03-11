import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/item.dart';

/// State for the inventory page. Holds a list of items representing
/// the userâ€™s inventory. Extends [BaseState] to reuse status and
/// error handling.
class InventoryState extends BaseState<List<Item>> {
  const InventoryState(
      {Status status = Status.initial, List<Item>? data, String? message})
      : super(status: status, data: data, message: message);

  InventoryState copyWith({Status? status, List<Item>? data, String? message}) {
    return InventoryState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
