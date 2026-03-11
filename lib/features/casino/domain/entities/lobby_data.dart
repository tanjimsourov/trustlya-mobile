import 'game.dart';
import 'promotion.dart';
import 'winner.dart';

/// Container class for all data required to render the casino lobby.
class CasinoLobbyData {
  /// List of available game categories (e.g. Slots, Roulette, Blackjack).
  final List<String> categories;

  /// Games to highlight in a featured section.
  final List<Game> featuredGames;

  /// Promotional cards to display in a carousel or list.
  final List<Promotion> promotions;

  /// Recent winners to display in a ticker or marquee.
  final List<Winner> recentWinners;

  /// Recommended games for the user based on popularity.
  final List<Game> recommendedGames;

  CasinoLobbyData({
    required this.categories,
    required this.featuredGames,
    required this.promotions,
    required this.recentWinners,
    required this.recommendedGames,
  });
}
