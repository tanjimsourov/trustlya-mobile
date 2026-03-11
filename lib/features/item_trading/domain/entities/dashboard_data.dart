import 'item.dart';
import 'trade.dart';

/// High level summary for the trading dashboard. Includes total
/// inventory value, daily/weekly gain or loss, a list of trending
/// items, an alerts summary and recent trades. The gainLoss value can
/// be positive or negative representing profit or loss respectively.
class ItemTradingDashboardData {
  final double totalValue;
  final double gainLoss;
  final List<Item> trending;
  final List<String> alerts;
  final List<Trade> recentTrades;

  ItemTradingDashboardData({
    required this.totalValue,
    required this.gainLoss,
    required this.trending,
    required this.alerts,
    required this.recentTrades,
  });
}
