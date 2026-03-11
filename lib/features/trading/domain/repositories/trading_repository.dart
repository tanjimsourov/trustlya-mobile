import '../../../../core/utils/result.dart';
import '../entities/market_asset.dart';
import '../entities/asset_detail.dart';
import '../entities/order.dart';

/// Contract for trading feature operations.
abstract class TradingRepository {
  Future<Result<List<MarketAsset>>> getMarketAssets();
  Future<Result<AssetDetail>> getAssetDetail(String id);
  Future<Result<void>> placeOrder(Order order);
  Future<Result<List<Order>>> getOrderHistory();
}
