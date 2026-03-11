import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/routes.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/promotion_offer.dart';
import '../../domain/repositories/promotions_repository.dart';

abstract class PromotionsDataSource implements PromotionsRepository {}

class MockPromotionsDataSource implements PromotionsDataSource {
  final List<PromotionOffer> _offers = [
    PromotionOffer(
      id: 'promo_welcome',
      title: 'Welcome Bonus',
      description: 'Get a \$10 bonus when you complete your first deposit.',
      category: 'General',
      icon: Icons.card_giftcard,
      route: Routes.rewards,
      arguments: null,
    ),
    PromotionOffer(
      id: 'promo_double_deposit',
      title: 'Double Deposit Day',
      description: 'Deposit any asset today and get a chance to double it!',
      category: 'Wallet',
      icon: Icons.wallet_giftcard,
      route: Routes.deposit,
      arguments: 'BTC',
    ),
    PromotionOffer(
      id: 'promo_no_fees',
      title: '0% Trading Fees',
      description: 'Trade items today with zero fees for the next 24h.',
      category: 'Trading',
      icon: Icons.trending_up,
      route: Routes.tradingDashboard,
      arguments: null,
    ),
    PromotionOffer(
      id: 'promo_free_spins',
      title: 'Free Spins',
      description: 'Claim 20 free spins on any slot game.',
      category: 'Casino',
      icon: Icons.casino,
      route: Routes.bonusRewards,
      arguments: null,
    ),
    PromotionOffer(
      id: 'promo_carbon_discount',
      title: 'Offset Discount',
      description: 'Buy carbon credits today and save 10%.',
      category: 'Carbon',
      icon: Icons.eco,
      route: Routes.carbonProjects,
      arguments: null,
    ),
  ];

  @override
  Future<Result<List<PromotionOffer>>> getPromotions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Result.success(List<PromotionOffer>.from(_offers));
  }
}

class PromotionsRepositoryImpl implements PromotionsRepository {
  PromotionsRepositoryImpl({PromotionsDataSource? dataSource})
      : _dataSource = dataSource ?? MockPromotionsDataSource();

  final PromotionsDataSource _dataSource;

  @override
  Future<Result<List<PromotionOffer>>> getPromotions() {
    return _dataSource.getPromotions();
  }
}
