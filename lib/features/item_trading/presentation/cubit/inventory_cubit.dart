import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/item.dart';
import '../../domain/repositories/item_trading_repository.dart';
import 'inventory_state.dart';

/// Cubit that loads and exposes the user’s item inventory. It
/// forwards repository results into a state which can be consumed
/// by the inventory page. Filtering and sorting are handled at the
/// UI layer for simplicity.
class InventoryCubit extends Cubit<InventoryState> {
  final ItemTradingRepository _repository;
  InventoryCubit(this._repository) : super(const InventoryState());

  Future<void> loadInventory() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getInventory();
    if (result is Success<List<Item>>) {
      if (result.value.isEmpty) {
        emit(state.copyWith(status: Status.empty, data: []));
      } else {
        emit(state.copyWith(status: Status.success, data: result.value));
      }
    } else if (result is Error<List<Item>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
