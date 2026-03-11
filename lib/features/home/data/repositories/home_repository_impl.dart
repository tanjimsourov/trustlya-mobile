import 'dart:async';

import '../../../../core/utils/result.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/entities/home_item.dart';
import '../../domain/entities/news_item.dart';
import '../../domain/repositories/home_repository.dart';

abstract class HomeDataSource implements HomeRepository {}

class MockHomeDataSource implements HomeDataSource {
  @override
  Future<Result<DashboardData>> getDashboardData() async {
    await Future.delayed(const Duration(seconds: 1));
    return Result.success(DashboardData(
      portfolioValue: 12345.67,
      openOrders: 2,
      notifications: 5,
    ));
  }

  @override
  Future<Result<List<HomeItem>>> getTrendingAssets() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return Result.success([
      HomeItem(id: 'btc', name: 'Bitcoin', price: 45000.0, change24h: 2.5),
      HomeItem(id: 'eth', name: 'Ethereum', price: 3000.0, change24h: -1.2),
      HomeItem(id: 'bnb', name: 'Binance Coin', price: 400.0, change24h: 0.8),
    ]);
  }

  @override
  Future<Result<List<NewsItem>>> getNews() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return Result.success([
      NewsItem(
        id: '1',
        title: 'Trustlya expands tokenization and post-trade tooling',
        summary:
            'Issuer workflows and settlement controls are now available in the platform workspace.',
      ),
      NewsItem(
        id: '2',
        title: 'Operational wallet and carbon marketplace updated',
        summary:
            'Wallet rails, holdings management, and retirement reporting continue to mature.',
      ),
    ]);
  }

  @override
  Future<Result<List<HomeItem>>> search(String query) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final all = [
      HomeItem(id: 'btc', name: 'Bitcoin', price: 45000.0, change24h: 2.5),
      HomeItem(id: 'eth', name: 'Ethereum', price: 3000.0, change24h: -1.2),
      HomeItem(id: 'bnb', name: 'Binance Coin', price: 400.0, change24h: 0.8),
    ];
    final filtered = all
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return Result.success(filtered);
  }
}

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({HomeDataSource? dataSource})
      : _dataSource = dataSource ?? MockHomeDataSource();

  final HomeDataSource _dataSource;

  @override
  Future<Result<DashboardData>> getDashboardData() {
    return _dataSource.getDashboardData();
  }

  @override
  Future<Result<List<HomeItem>>> getTrendingAssets() {
    return _dataSource.getTrendingAssets();
  }

  @override
  Future<Result<List<NewsItem>>> getNews() {
    return _dataSource.getNews();
  }

  @override
  Future<Result<List<HomeItem>>> search(String query) {
    return _dataSource.search(query);
  }
}
