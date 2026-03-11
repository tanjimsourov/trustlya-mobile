import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/item.dart';

/// State for the item detail page. Holds a single [Item] object.
class ItemDetailState extends BaseState<Item> {
  const ItemDetailState(
      {Status status = Status.initial, Item? data, String? message})
      : super(status: status, data: data, message: message);

  ItemDetailState copyWith({Status? status, Item? data, String? message}) {
    return ItemDetailState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
