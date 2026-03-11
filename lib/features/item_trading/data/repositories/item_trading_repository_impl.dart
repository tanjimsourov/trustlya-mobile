import 'dart:async';

import '../../../../core/utils/result.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/trade.dart';
import '../../domain/entities/trader_profile.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/entities/portfolio_analytics.dart';
import '../../domain/entities/watchlist_item.dart';
import '../../domain/repositories/item_trading_repository.dart';

/// Mock implementation of [ItemTradingRepository] providing
/// in‑memory data for game item trading. All operations simulate
/// network latency via small delays and never throw exceptions.
class ItemTradingRepositoryImpl implements ItemTradingRepository {
  final List<Item> _items = [
    Item(
      id: 'ak-47',
      game: 'CS2',
      name: 'AK‑47 | Redline',
      rarity: 'Classified',
      wear: 0.15,
      price: 250,
      imageUrl: 'https://placehold.co/200x200?text=AK‑47',
    ),
    Item(
      id: 'm4a1',
      game: 'CS2',
      name: 'M4A1‑S | Hyper Beast',
      rarity: 'Covert',
      wear: 0.05,
      price: 350,
      imageUrl: 'https://placehold.co/200x200?text=M4A1‑S',
    ),
    Item(
      id: 'dragon-lore',
      game: 'CS2',
      name: 'AWP | Dragon Lore',
      rarity: 'Covert',
      wear: 0.01,
      price: 5000,
      imageUrl: 'https://placehold.co/200x200?text=Dragon+Lore',
    ),
    Item(
      id: 'karambit',
      game: 'CS2',
      name: 'Karambit | Doppler',
      rarity: 'Covert',
      wear: 0.03,
      price: 1500,
      imageUrl: 'https://placehold.co/200x200?text=Karambit',
    ),
    Item(
      id: 'm9-lore',
      game: 'CS2',
      name: 'M9 Bayonet | Lore',
      rarity: 'Covert',
      wear: 0.22,
      price: 800,
      imageUrl: 'https://placehold.co/200x200?text=M9+Lore',
    ),
    Item(
      id: 'glock',
      game: 'CS2',
      name: 'Glock‑18 | Fade',
      rarity: 'Restricted',
      wear: 0.20,
      price: 180,
      imageUrl: 'https://placehold.co/200x200?text=Glock+Fade',
    ),
  ];

  final List<Trade> _trades = [];

  final List<WatchlistItem> _watchlist = [];

  @override
  Future<Result<ItemTradingDashboardData>> getDashboardData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Sum total inventory value
    final total = _items.fold<double>(0, (sum, item) => sum + item.price);
    // For demo, calculate random gain/loss from initial value
    final gainLoss = 200.0; // positive means profit
    // Trending: top 3 most expensive items
    final trending = List<Item>.from(_items)
      ..sort((a, b) => b.price.compareTo(a.price));
    final trendingTop = trending.take(3).toList();
    // Alerts: check watchlist for items nearing target price
    final alerts = <String>[];
    for (final entry in _watchlist) {
      if (entry.targetPrice != null &&
          (entry.item.price >= entry.targetPrice! * 0.9)) {
        alerts.add('${entry.item.name} is nearing your target price');
      }
    }
    // Recent trades: take last 3
    final recent = List<Trade>.from(_trades.reversed.take(3));
    final data = ItemTradingDashboardData(
      totalValue: total,
      gainLoss: gainLoss,
      trending: trendingTop,
      alerts: alerts,
      recentTrades: recent,
    );
    return Result.success(data);
  }

  @override
  Future<Result<List<Item>>> getInventory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(List.unmodifiable(_items));
  }

  @override
  Future<Result<Item>> getItemDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      final item = _items.firstWhere((i) => i.id == id);
      return Result.success(item);
    } catch (_) {
      return Result.error('Item not found');
    }
  }

  @override
  Future<Result<List<Item>>> getMarketItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // For this mock, the market includes all items plus duplicates to simulate variety
    final market = List<Item>.from(_items)
      ..addAll(
          _items.map((e) => e.copyWith(id: '${e.id}-m1', price: e.price * 1.1)))
      ..addAll(_items
          .map((e) => e.copyWith(id: '${e.id}-m2', price: e.price * 0.9)));
    return Result.success(market);
  }

  @override
  Future<Result<Trade>> createTrade(
      List<Item> offered, List<Item> requested) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final offeredValue =
        offered.fold<double>(0, (sum, item) => sum + item.price);
    final requestedValue =
        requested.fold<double>(0, (sum, item) => sum + item.price);
    final trade = Trade(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      offered: offered,
      requested: requested,
      offeredValue: offeredValue,
      requestedValue: requestedValue,
      counterparty: 'Trader123',
      status: 'completed',
    );
    _trades.add(trade);
    return Result.success(trade);
  }

  @override
  Future<Result<List<Trade>>> getTradeHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(List.unmodifiable(_trades.reversed.toList()));
  }

  @override
  Future<Result<PortfolioAnalytics>> getPortfolioAnalytics() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final performance = <Map<String, double>>[];
    // Generate 7 days of dummy performance data
    for (int i = 0; i < 7; i++) {
      performance.add({
        DateTime.now()
            .subtract(Duration(days: 6 - i))
            .millisecondsSinceEpoch
            .toString(): 1000 + i * 150.0
      });
    }
    final rarityDistribution = <String, int>{};
    for (final item in _items) {
      rarityDistribution[item.rarity] =
          (rarityDistribution[item.rarity] ?? 0) + 1;
    }
    final best = List<Item>.from(_items)
      ..sort((a, b) => b.price.compareTo(a.price));
    final analytics = PortfolioAnalytics(
      performance: performance,
      rarityDistribution: rarityDistribution,
      bestItems: best.take(3).toList(),
      totalProfit: 500,
      totalLoss: 100,
    );
    return Result.success(analytics);
  }

  @override
  Future<Result<List<WatchlistItem>>> getWatchlist() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return Result.success(List.unmodifiable(_watchlist));
  }

  @override
  Future<Result<TraderProfile>> getTraderProfile(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Provide a dummy profile regardless of id
    final preview = List<Item>.from(_items.take(3));
    final profile = TraderProfile(
      id: id,
      name: 'Trader $id',
      trustScore: 4.7,
      completedTrades: 42,
      badges: ['Top Trader', 'Trusted'],
      inventoryPreview: preview,
      avatarUrl: 'https://placehold.co/100x100?text=T$id',
    );
    return Result.success(profile);
  }
}
