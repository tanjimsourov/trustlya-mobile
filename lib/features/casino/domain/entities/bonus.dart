/// Represents a bonus or reward available to the user in the casino.
class Bonus {
  final String id;
  final String title;
  final String description;

  /// A value between 0 and 1 indicating progress toward unlocking or claiming the bonus.
  final double progress;

  /// Indicates if the bonus can currently be claimed.
  final bool claimable;

  Bonus({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.claimable,
  });
}
