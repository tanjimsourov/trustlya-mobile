import 'item.dart';

/// Represents analytics for a player’s item portfolio. Includes a
/// performance time series for value over time, distribution of
/// rarities, top performing items by appreciation and profit/loss
/// breakdown cards. The time series is represented as a list of
/// (timestamp, value) pairs to allow simple plotting.
class PortfolioAnalytics {
  final List<Map<String, double>> performance; // [{'timestamp': value}, ...]
  final Map<String, int> rarityDistribution;
  final List<Item> bestItems;
  final double totalProfit;
  final double totalLoss;

  PortfolioAnalytics({
    required this.performance,
    required this.rarityDistribution,
    required this.bestItems,
    required this.totalProfit,
    required this.totalLoss,
  });
}
