import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/routes.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/discover_item.dart';
import '../../domain/repositories/discover_repository.dart';

abstract class DiscoverDataSource implements DiscoverRepository {}

class MockDiscoverDataSource implements DiscoverDataSource {
  final List<DiscoverItem> _items = [
    DiscoverItem(
      id: 'disc_item_1',
      title: 'AK-47 Redline Trending',
      description: 'This popular item is seeing strong demand.',
      type: 'Items',
      icon: Icons.inventory_2,
      route: Routes.itemDetail,
      arguments: 'ak47',
    ),
    DiscoverItem(
      id: 'disc_item_2',
      title: 'ETH Hits New Highs',
      description: 'Ethereum has rallied 5% this week.',
      type: 'Assets',
      icon: Icons.currency_bitcoin,
      route: Routes.assetDetail,
      arguments: 'ETH',
    ),
    DiscoverItem(
      id: 'disc_item_3',
      title: 'Try Lightning Roulette',
      description: 'Experience high-voltage wins in Roulette.',
      type: 'Games',
      icon: Icons.casino,
      route: Routes.rouletteGame,
      arguments: null,
    ),
    DiscoverItem(
      id: 'disc_item_4',
      title: 'Support Rainforest Project',
      description: 'Offset carbon by contributing to this project.',
      type: 'Carbon',
      icon: Icons.eco,
      route: Routes.carbonProjectDetail,
      arguments: 'rainforest',
    ),
    DiscoverItem(
      id: 'disc_item_5',
      title: 'Complete Your KYC',
      description: 'Unlock higher limits and bonuses by verifying.',
      type: 'Articles',
      icon: Icons.verified_user,
      route: Routes.kycStatus,
      arguments: null,
    ),
    DiscoverItem(
      id: 'disc_enterprise_1',
      title: 'Launch Tokenization Program',
      description: 'Digitize assets and onboard investors with Trustlya.',
      type: 'Enterprise',
      icon: Icons.layers,
      route: Routes.tokenizationOverview,
      arguments: null,
    ),
    DiscoverItem(
      id: 'disc_enterprise_2',
      title: 'Streamline Post-Trade Operations',
      description: 'Monitor settlement, reconciliation and exceptions.',
      type: 'Enterprise',
      icon: Icons.swap_vert,
      route: Routes.postTradeDashboard,
      arguments: null,
    ),
  ];

  @override
  Future<Result<List<DiscoverItem>>> getDiscoverItems() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return Result.success(List<DiscoverItem>.from(_items));
  }
}

class DiscoverRepositoryImpl implements DiscoverRepository {
  DiscoverRepositoryImpl({DiscoverDataSource? dataSource})
      : _dataSource = dataSource ?? MockDiscoverDataSource();

  final DiscoverDataSource _dataSource;

  @override
  Future<Result<List<DiscoverItem>>> getDiscoverItems() {
    return _dataSource.getDiscoverItems();
  }
}
