import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/item.dart';
import '../../domain/repositories/item_trading_repository.dart';
import 'market_state.dart';

/// Cubit for loading and managing market items. It fetches a list of
/// items from the repository and exposes it via a [MarketState].
class MarketCubit extends Cubit<MarketState> {
  final ItemTradingRepository _repository;
  MarketCubit(this._repository) : super(const MarketState());

  Future<void> loadMarket() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getMarketItems();
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
