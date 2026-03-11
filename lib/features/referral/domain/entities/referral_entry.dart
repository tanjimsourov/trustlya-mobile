/// Represents a single referred user in the referral module. The
/// [name] identifies the user and [rewardEarned] indicates any
/// reward or bonus associated with the referral.
class ReferralEntry {
  final String name;
  final String joinedDate;
  final String rewardEarned;

  const ReferralEntry(
      {required this.name,
      required this.joinedDate,
      required this.rewardEarned});
}
