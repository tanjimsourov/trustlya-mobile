import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/watchlist_item.dart';

/// State for the watchlist page. Holds a list of [WatchlistItem].
class WatchlistState extends BaseState<List<WatchlistItem>> {
  const WatchlistState(
      {Status status = Status.initial,
      List<WatchlistItem>? data,
      String? message})
      : super(status: status, data: data, message: message);

  WatchlistState copyWith(
      {Status? status, List<WatchlistItem>? data, String? message}) {
    return WatchlistState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
