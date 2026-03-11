import 'item.dart';

/// Public profile for a trader. Contains their display name, trust
/// score, number of completed trades, badge titles and a preview of
/// their inventory. The inventory preview may contain a few items to
/// show off the trader’s collection.
class TraderProfile {
  final String id;
  final String name;
  final double trustScore;
  final int completedTrades;
  final List<String> badges;
  final List<Item> inventoryPreview;
  final String avatarUrl;

  TraderProfile({
    required this.id,
    required this.name,
    required this.trustScore,
    required this.completedTrades,
    required this.badges,
    required this.inventoryPreview,
    required this.avatarUrl,
  });
}
