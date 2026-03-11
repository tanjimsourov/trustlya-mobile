import 'dart:async';

import '../../../../core/utils/result.dart';
import '../../domain/entities/referral_data.dart';
import '../../domain/entities/referral_entry.dart';
import '../../domain/repositories/referral_repository.dart';

/// Mock implementation of [ReferralRepository]. Stores a static
/// referral code and a list of referred users. Inviting a new user
/// adds them to the list with a random reward (simulated as
/// instant reward earned).
class ReferralRepositoryImpl implements ReferralRepository {
  ReferralData _data = ReferralData(
    code: 'TRUSTLYA123',
    referrals: [
      ReferralEntry(
          name: 'Alice', joinedDate: '2026-01-10', rewardEarned: '\$10'),
      ReferralEntry(
          name: 'Bob', joinedDate: '2026-02-05', rewardEarned: '\$15'),
    ],
    rewardStats: '\$25 total rewards',
  );

  @override
  Future<Result<ReferralData>> getReferralData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Result.success(_data);
  }

  @override
  Future<Result<ReferralData>> invite(String name) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (name.trim().isEmpty) {
      return Result.error('Enter a valid name');
    }
    final newEntry = ReferralEntry(
      name: name,
      joinedDate: DateTime.now().toString().split(' ').first,
      rewardEarned: '\$5',
    );
    final updatedReferrals = List<ReferralEntry>.from(_data.referrals)
      ..add(newEntry);
    final updatedStats =
        '\$${(int.parse(_data.rewardStats.replaceAll(RegExp('[^0-9]'), '')) + 5)} total rewards';
    _data = ReferralData(
        code: _data.code,
        referrals: updatedReferrals,
        rewardStats: updatedStats);
    return Result.success(_data);
  }
}
