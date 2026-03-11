import 'insight_item.dart';

/// Aggregated data for the market insights page. Includes the
/// [topMovers] list, [volatility] list and [blurbs] of educational
/// tips or commentary.
class MarketInsightsData {
  final List<InsightItem> topMovers;
  final List<InsightItem> volatility;
  final List<String> blurbs;

  const MarketInsightsData({
    this.topMovers = const [],
    this.volatility = const [],
    this.blurbs = const [],
  });
}
