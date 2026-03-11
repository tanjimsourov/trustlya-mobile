import 'dart:async';

import '../../../../core/utils/result.dart';
import '../../domain/entities/asset_detail.dart';
import '../../domain/entities/market_asset.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/trading_repository.dart';

abstract class TradingDataSource implements TradingRepository {}

class MockTradingDataSource implements TradingDataSource {
  final List<MarketAsset> _assets = [
    MarketAsset(
        id: 'btc',
        symbol: 'BTC',
        name: 'Bitcoin',
        price: 45000,
        volume24h: 1000000000),
    MarketAsset(
        id: 'eth',
        symbol: 'ETH',
        name: 'Ethereum',
        price: 3000,
        volume24h: 500000000),
    MarketAsset(
        id: 'bnb',
        symbol: 'BNB',
        name: 'Binance Coin',
        price: 400,
        volume24h: 200000000),
  ];

  final List<Order> _orderHistory = [];

  @override
  Future<Result<List<MarketAsset>>> getMarketAssets() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return Result.success(_assets);
  }

  @override
  Future<Result<AssetDetail>> getAssetDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final asset =
        _assets.firstWhere((a) => a.id == id, orElse: () => _assets.first);
    return Result.success(AssetDetail(
      id: asset.id,
      symbol: asset.symbol,
      name: asset.name,
      price: asset.price,
      change24h: 2.5,
      marketCap: 1000000000,
      supply: 21000000,
    ));
  }

  @override
  Future<Result<void>> placeOrder(Order order) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _orderHistory.add(order);
    return const Result.success(null);
  }

  @override
  Future<Result<List<Order>>> getOrderHistory() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Result.success(List.unmodifiable(_orderHistory));
  }
}

class TradingRepositoryImpl implements TradingRepository {
  TradingRepositoryImpl({TradingDataSource? dataSource})
      : _dataSource = dataSource ?? MockTradingDataSource();

  final TradingDataSource _dataSource;

  @override
  Future<Result<List<MarketAsset>>> getMarketAssets() {
    return _dataSource.getMarketAssets();
  }

  @override
  Future<Result<AssetDetail>> getAssetDetail(String id) {
    return _dataSource.getAssetDetail(id);
  }

  @override
  Future<Result<void>> placeOrder(Order order) {
    return _dataSource.placeOrder(order);
  }

  @override
  Future<Result<List<Order>>> getOrderHistory() {
    return _dataSource.getOrderHistory();
  }
}
