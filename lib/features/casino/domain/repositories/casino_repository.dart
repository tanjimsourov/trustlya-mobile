import '../../../../core/utils/result.dart';
import '../entities/game.dart';
import '../entities/game_history_item.dart';
import '../entities/lobby_data.dart';
import '../entities/game_detail.dart';
import '../entities/bet_history.dart';
import '../entities/bonus.dart';
import '../entities/vip_info.dart';
import '../entities/responsible_gaming_info.dart';

/// Contract for casino operations. Provides methods to fetch lobby data,
/// game details, play games with a bet amount, retrieve betting history,
/// bonuses, VIP information and responsible gaming settings.
abstract class CasinoRepository {
  /// Returns aggregated data for the casino lobby, including categories,
  /// featured games, promotions, recent winners and recommended games.
  Future<Result<CasinoLobbyData>> getLobbyData();

  /// Returns detailed information for a specific game identified by [id].
  Future<Result<GameDetail>> getGameDetail(String id);

  /// Simulates playing a slots game with the given [bet] amount.
  Future<Result<BetHistoryItem>> playSlots([double bet = 1.0]);

  /// Simulates playing a roulette game with the given [bet] amount.
  Future<Result<BetHistoryItem>> playRoulette(double bet);

  /// Simulates playing a blackjack game with the given [bet] amount.
  Future<Result<BetHistoryItem>> playBlackjack(double bet);

  /// Retrieves the user’s betting history across all casino games.
  Future<Result<List<BetHistoryItem>>> getBetHistory();

  /// Returns a list of available bonuses and rewards.
  Future<Result<List<Bonus>>> getBonuses();

  /// Attempts to claim the bonus identified by [id].
  Future<Result<void>> claimBonus(String id);

  /// Returns the user’s current VIP or loyalty information including tiers.
  Future<Result<VipInfo>> getVipInfo();

  /// Returns responsible gaming information and settings for the user.
  Future<Result<ResponsibleGamingInfo>> getResponsibleGamingInfo();

  // ----------------------------------------------------------------------
  // Backwards compatibility: legacy methods used by older pages. These
  // methods internally call the new API with default bet amounts and
  // converted types. They should not be used in new code.

  /// Legacy: returns the list of games shown in the lobby. This simply
  /// returns the `featuredGames` from [getLobbyData].
  Future<Result<List<Game>>> getLobbyGames();

  /// Legacy: plays a poker game. Poker has been replaced by blackjack in
  /// the new API. This method delegates to [playBlackjack] with a
  /// default bet and sets the game name to "Poker".
  Future<Result<GameHistoryItem>> playPoker();

  /// Legacy: retrieves the game history. This delegates to
  /// [getBetHistory].
  Future<Result<List<GameHistoryItem>>> getHistory();
}
