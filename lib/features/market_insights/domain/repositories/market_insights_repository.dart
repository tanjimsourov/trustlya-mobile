import '../../../../core/utils/result.dart';
import '../entities/insight_item.dart';

/// Contract for fetching market insights and trends across all
/// modules. Returns top movers, volatility data and educational
/// blurbs.
abstract class MarketInsightsRepository {
  Future<Result<List<InsightItem>>> getTopMovers();
  Future<Result<List<InsightItem>>> getVolatility();
  Future<Result<List<String>>> getEducationalBlurbs();
}
