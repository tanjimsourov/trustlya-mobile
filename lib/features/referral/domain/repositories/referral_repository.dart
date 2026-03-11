import '../../../../core/utils/result.dart';
import '../entities/referral_data.dart';

/// Contract for managing referrals and invites.
abstract class ReferralRepository {
  Future<Result<ReferralData>> getReferralData();
  Future<Result<ReferralData>> invite(String name);
}
