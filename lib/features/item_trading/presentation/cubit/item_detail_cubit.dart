import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/item.dart';
import '../../domain/repositories/item_trading_repository.dart';
import 'item_detail_state.dart';

/// Cubit for loading the details of a single item. It uses the
/// [ItemTradingRepository] to fetch item data by id and exposes it via
/// a state containing an [Item].
class ItemDetailCubit extends Cubit<ItemDetailState> {
  final ItemTradingRepository _repository;
  ItemDetailCubit(this._repository) : super(const ItemDetailState());

  Future<void> loadItem(String id) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getItemDetail(id);
    if (result is Success<Item>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<Item>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
