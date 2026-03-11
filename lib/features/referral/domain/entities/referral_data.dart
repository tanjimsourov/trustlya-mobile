import 'referral_entry.dart';

/// Aggregated data for the referral screen. Contains the referral
/// [code], the list of [referrals] and a [rewardStats] string
/// describing the accumulated rewards from referrals.
class ReferralData {
  final String code;
  final List<ReferralEntry> referrals;
  final String rewardStats;

  const ReferralData(
      {required this.code, required this.referrals, required this.rewardStats});
}
