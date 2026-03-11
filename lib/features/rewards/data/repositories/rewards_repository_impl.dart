import 'dart:async';

import '../../../../core/utils/result.dart';
import '../../domain/entities/mission.dart';
import '../../domain/repositories/rewards_repository.dart';

/// Mock implementation of [RewardsRepository]. Provides a list of
/// missions spanning multiple modules and handles claiming rewards.
class RewardsRepositoryImpl implements RewardsRepository {
  final List<Mission> _missions = [
    Mission(
      id: 'm1',
      title: 'Complete Your First Trade',
      description: 'Execute a game item trade.',
      progress: 0.6,
      required: 1,
      current: 0.6,
      reward: '50 XP',
      module: 'Trading',
      claimed: false,
    ),
    Mission(
      id: 'm2',
      title: 'Deposit to Wallet',
      description: 'Deposit any cryptocurrency.',
      progress: 1.0,
      required: 1,
      current: 1.0,
      reward: 'Free Spin',
      module: 'Wallet',
      claimed: false,
    ),
    Mission(
      id: 'm3',
      title: 'Play a Casino Game',
      description: 'Play any casino game once.',
      progress: 0.3,
      required: 1,
      current: 0.3,
      reward: '10% Cashback',
      module: 'Casino',
      claimed: false,
    ),
    Mission(
      id: 'm4',
      title: 'Offset Carbon',
      description: 'Retire carbon credits.',
      progress: 0.0,
      required: 1,
      current: 0.0,
      reward: 'Eco Badge',
      module: 'Carbon',
      claimed: false,
    ),
  ];

  @override
  Future<Result<List<Mission>>> getMissions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Result.success(List<Mission>.from(_missions));
  }

  @override
  Future<Result<Mission>> claimReward(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _missions.indexWhere((m) => m.id == id);
    if (index < 0) {
      return Result.error('Mission not found');
    }
    final mission = _missions[index];
    if (mission.progress < 1.0) {
      return Result.error('Mission not yet complete');
    }
    if (mission.claimed) {
      return Result.error('Reward already claimed');
    }
    _missions[index] = mission.copyWith(claimed: true);
    return Result.success(_missions[index]);
  }
}
