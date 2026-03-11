import '../../../../core/utils/result.dart';
import '../entities/item.dart';
import '../entities/trade.dart';
import '../entities/trader_profile.dart';
import '../entities/dashboard_data.dart';
import '../entities/portfolio_analytics.dart';
import '../entities/watchlist_item.dart';

/// Contract for game item trading operations. All methods return a
/// [Result] to encapsulate success or failure with optional messages.
abstract class ItemTradingRepository {
  Future<Result<ItemTradingDashboardData>> getDashboardData();
  Future<Result<List<Item>>> getInventory();
  Future<Result<Item>> getItemDetail(String id);
  Future<Result<List<Item>>> getMarketItems();
  Future<Result<Trade>> createTrade(List<Item> offered, List<Item> requested);
  Future<Result<List<Trade>>> getTradeHistory();
  Future<Result<PortfolioAnalytics>> getPortfolioAnalytics();
  Future<Result<List<WatchlistItem>>> getWatchlist();
  Future<Result<TraderProfile>> getTraderProfile(String id);
}
