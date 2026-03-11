/// Detailed information about a casino game. Used on the game detail screen.
class GameDetail {
  final String id;
  final String name;
  final String description;

  /// Path or network URL to the hero artwork for the game.
  final String heroImage;

  /// Return to player percentage (e.g. 96.5).
  final double rtp;
  final double minBet;
  final double maxBet;
  final List<String> tags;

  GameDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.heroImage,
    required this.rtp,
    required this.minBet,
    required this.maxBet,
    required this.tags,
  });
}
