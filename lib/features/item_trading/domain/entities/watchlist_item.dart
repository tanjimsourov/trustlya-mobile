import 'item.dart';

/// A watchlist entry for a game item. Contains the item itself,
/// an optional target price for alerting and whether the user has
/// already been alerted about the latest change. In a real app this
/// could include alert types (e.g. above/below threshold).
class WatchlistItem {
  final Item item;
  final double? targetPrice;
  final bool alerted;

  WatchlistItem({required this.item, this.targetPrice, this.alerted = false});
}
