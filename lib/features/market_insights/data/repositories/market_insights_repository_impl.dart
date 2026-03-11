import 'dart:async';

import '../../../../core/utils/result.dart';
import '../../domain/entities/insight_item.dart';
import '../../domain/repositories/market_insights_repository.dart';

/// Mock implementation of [MarketInsightsRepository]. Provides
/// synthetic lists of top movers, volatility insights and
/// educational blurbs.
class MarketInsightsRepositoryImpl implements MarketInsightsRepository {
  final List<InsightItem> _topMovers = [
    InsightItem(
        id: 'BTC',
        name: 'Bitcoin',
        type: 'Asset',
        value: 48000.0,
        change: 5.2,
        extra: 'High'),
    InsightItem(
        id: 'AK-47',
        name: 'AK‑47 Redline',
        type: 'Item',
        value: 250.0,
        change: -3.4,
        extra: 'Medium'),
    InsightItem(
        id: 'Roulette',
        name: 'Roulette',
        type: 'Game',
        value: 1.2,
        change: 2.1,
        extra: 'Low'),
    InsightItem(
        id: 'Rainforest',
        name: 'Rainforest Preservation',
        type: 'Carbon',
        value: 12.5,
        change: 1.1,
        extra: 'Low'),
  ];

  final List<InsightItem> _volatility = [
    InsightItem(
        id: 'ETH',
        name: 'Ethereum',
        type: 'Asset',
        value: 3600.0,
        change: 8.7,
        extra: 'Very High'),
    InsightItem(
        id: 'M9',
        name: 'M9 Bayonet Lore',
        type: 'Item',
        value: 1500.0,
        change: 10.5,
        extra: 'High'),
    InsightItem(
        id: 'Slots',
        name: 'Slots',
        type: 'Game',
        value: 0.9,
        change: -1.2,
        extra: 'Medium'),
    InsightItem(
        id: 'Wind Farm',
        name: 'Wind Farm Expansion',
        type: 'Carbon',
        value: 9.0,
        change: 0.8,
        extra: 'Low'),
  ];

  final List<String> _blurbs = [
    'Diversify your assets to reduce risk in volatile markets.',
    'Consider locking profits on items that have surged recently.',
    'Eco projects may provide long‑term stability with moderate returns.',
    'Volatility often presents opportunities for strategic trades.',
  ];

  @override
  Future<Result<List<InsightItem>>> getTopMovers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Result.success(List<InsightItem>.from(_topMovers));
  }

  @override
  Future<Result<List<InsightItem>>> getVolatility() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Result.success(List<InsightItem>.from(_volatility));
  }

  @override
  Future<Result<List<String>>> getEducationalBlurbs() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Result.success(List<String>.from(_blurbs));
  }
}
