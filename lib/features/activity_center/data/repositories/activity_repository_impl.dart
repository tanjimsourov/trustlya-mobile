import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/activity_item.dart';
import '../../domain/repositories/activity_repository.dart';

abstract class ActivityDataSource implements ActivityRepository {}

class MockActivityDataSource implements ActivityDataSource {
  final List<ActivityItem> _events = [
    ActivityItem(
      id: 'act1',
      type: 'Wallet',
      title: 'Deposit confirmed',
      description: 'Incoming BTC funding posted to the operational wallet',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      icon: Icons.arrow_downward,
      color: AppColorsDS.success,
    ),
    ActivityItem(
      id: 'act2',
      type: 'Tokenization',
      title: 'Issuer review completed',
      description:
          'Baltic Infrastructure Note program moved into issuance preparation',
      date: DateTime.now().subtract(const Duration(hours: 6)),
      icon: Icons.account_tree_outlined,
      color: AppColorsDS.primary,
    ),
    ActivityItem(
      id: 'act3',
      type: 'Settlement',
      title: 'Settlement instruction completed',
      description:
          'Instruction STL-2026-041 reached finality in EUR settlement',
      date: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      icon: Icons.fact_check_outlined,
      color: AppColorsDS.warning,
    ),
    ActivityItem(
      id: 'act4',
      type: 'Carbon',
      title: 'Credits retired',
      description: 'Retired 1200 credits from Andalusia Solar Grid Expansion',
      date: DateTime.now().subtract(const Duration(days: 2)),
      icon: Icons.eco,
      color: AppColorsDS.secondary,
    ),
    ActivityItem(
      id: 'act5',
      type: 'Wallet',
      title: 'Withdrawal submitted',
      description: 'Outbound ETH transfer routed for destination review',
      date: DateTime.now().subtract(const Duration(days: 3)),
      icon: Icons.arrow_upward,
      color: AppColorsDS.danger,
    ),
    ActivityItem(
      id: 'act6',
      type: 'Tokenization',
      title: 'New asset program',
      description:
          'Amsterdam Renewable Energy program was opened for onboarding',
      date: DateTime.now().subtract(const Duration(hours: 4)),
      icon: Icons.layers_outlined,
      color: AppColorsDS.primary,
    ),
    ActivityItem(
      id: 'act7',
      type: 'Tokenization',
      title: 'Investor approved',
      description: 'Investor onboarding completed for the Baltic note issuance',
      date: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      icon: Icons.person_add,
      color: AppColorsDS.success,
    ),
    ActivityItem(
      id: 'act8',
      type: 'Settlement',
      title: 'Treasury break resolved',
      description: 'Liquidity mismatch cleared and funding coverage restored',
      date: DateTime.now().subtract(const Duration(hours: 6)),
      icon: Icons.done_all_outlined,
      color: AppColorsDS.success,
    ),
    ActivityItem(
      id: 'act9',
      type: 'Settlement',
      title: 'Reconciliation break',
      description: 'Exception raised for Paris Arts settlement account mapping',
      date: DateTime.now().subtract(const Duration(days: 2)),
      icon: Icons.error_outline,
      color: AppColorsDS.warning,
    ),
  ];

  @override
  Future<Result<List<ActivityItem>>> getActivities() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final sorted = List<ActivityItem>.from(_events)
      ..sort((a, b) => b.date.compareTo(a.date));
    return Result.success(sorted);
  }
}

class ActivityRepositoryImpl implements ActivityRepository {
  ActivityRepositoryImpl({ActivityDataSource? dataSource})
      : _dataSource = dataSource ?? MockActivityDataSource();

  final ActivityDataSource _dataSource;

  @override
  Future<Result<List<ActivityItem>>> getActivities() {
    return _dataSource.getActivities();
  }
}
