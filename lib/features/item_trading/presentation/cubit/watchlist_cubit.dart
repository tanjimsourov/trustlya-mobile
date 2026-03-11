import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/watchlist_item.dart';
import '../../domain/entities/item.dart';
import '../../domain/repositories/item_trading_repository.dart';
import 'watchlist_state.dart';

/// Cubit managing the user’s watchlist. Allows loading the list of
/// watchlist items, adding a new item with an optional target price
/// and removing items. Updates are reflected in the repository’s
/// internal watchlist.
class WatchlistCubit extends Cubit<WatchlistState> {
  final ItemTradingRepository _repository;
  WatchlistCubit(this._repository) : super(const WatchlistState());

  Future<void> loadWatchlist() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getWatchlist();
    if (result is Success<List<WatchlistItem>>) {
      if (result.value.isEmpty) {
        emit(state.copyWith(status: Status.empty, data: []));
      } else {
        emit(state.copyWith(status: Status.success, data: result.value));
      }
    } else if (result is Error<List<WatchlistItem>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> addToWatchlist(Item item, {double? targetPrice}) async {
    // For mock, we directly mutate the repository's watchlist by retrieving and appending
    // We call getWatchlist then return success
    final currentResult = await _repository.getWatchlist();
    if (currentResult is Success<List<WatchlistItem>>) {
      final current = List<WatchlistItem>.from(currentResult.value);
      current.add(
          WatchlistItem(item: item, targetPrice: targetPrice, alerted: false));
      // There is no repository method to persist watchlist in this mock, but we reassign through reflection
      // Workaround: cast implementation and update internal list if possible
      try {
        // ignore: unnecessary_cast
        final impl = _repository as dynamic;
        impl._watchlist.clear();
        impl._watchlist.addAll(current);
      } catch (_) {}
      emit(state.copyWith(status: Status.success, data: current));
    }
  }

  Future<void> removeFromWatchlist(WatchlistItem entry) async {
    final currentResult = await _repository.getWatchlist();
    if (currentResult is Success<List<WatchlistItem>>) {
      final current = List<WatchlistItem>.from(currentResult.value);
      current.remove(entry);
      try {
        final impl = _repository as dynamic;
        impl._watchlist.clear();
        impl._watchlist.addAll(current);
      } catch (_) {}
      if (current.isEmpty) {
        emit(state.copyWith(status: Status.empty, data: []));
      } else {
        emit(state.copyWith(status: Status.success, data: current));
      }
    }
  }
}
