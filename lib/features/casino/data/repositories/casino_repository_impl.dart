import 'dart:async';
import 'dart:math';

import '../../../../core/utils/result.dart';
import '../../domain/entities/game.dart';
import '../../domain/entities/game_detail.dart';
import '../../domain/entities/lobby_data.dart';
import '../../domain/entities/promotion.dart';
import '../../domain/entities/winner.dart';
import '../../domain/entities/bonus.dart';
import '../../domain/entities/vip_info.dart';
import '../../domain/entities/bet_history.dart';
import '../../domain/entities/game_history_item.dart';
import '../../domain/entities/responsible_gaming_info.dart';
import '../../domain/repositories/casino_repository.dart';

/// Mock implementation of [CasinoRepository]. This class generates
/// pseudo‑random results for games and provides static data for lobby,
/// bonus and VIP screens. It also tracks betting history and
/// responsible gaming information.
class CasinoRepositoryImpl implements CasinoRepository {
  final Random _rand = Random();

  // Define a list of games available in the casino. Additional games can
  // be added here; only id, name and description are required for the
  // lobby. Detailed information is stored separately in [_gameDetails].
  final List<Game> _games = [
    Game(
        id: 'slots', name: 'Slots', description: 'Spin the reels and win big!'),
    Game(
        id: 'roulette',
        name: 'Roulette',
        description: 'Bet on numbers or colours and watch the wheel spin.'),
    Game(
        id: 'blackjack',
        name: 'Blackjack',
        description: 'Beat the dealer to 21 without going bust.'),
    Game(
        id: 'poker',
        name: 'Poker',
        description: 'Classic poker tables are coming soon.'),
    Game(
        id: 'live',
        name: 'Live Games',
        description: 'Interact with live dealers (coming soon).'),
    Game(
        id: 'sports',
        name: 'Sports & Esports',
        description: 'Bet on sports and esports events (coming soon).'),
  ];

  // Detailed information for each supported game. Keys match game ids.
  final Map<String, GameDetail> _gameDetails = {
    'slots': GameDetail(
      id: 'slots',
      name: 'Slots',
      description:
          'A classic slot machine with five reels and multiple paylines. Spin and hope for matching symbols! Includes wilds and free spins.',
      heroImage: '',
      rtp: 96.5,
      minBet: 0.10,
      maxBet: 100.0,
      tags: ['classic', 'high volatility', 'popular'],
    ),
    'roulette': GameDetail(
      id: 'roulette',
      name: 'Roulette',
      description:
          'Place your chips on numbers, colours or sections and watch the wheel determine your fate. Includes European and American variations.',
      heroImage: '',
      rtp: 97.3,
      minBet: 0.50,
      maxBet: 500.0,
      tags: ['table game', 'chance', 'strategic'],
    ),
    'blackjack': GameDetail(
      id: 'blackjack',
      name: 'Blackjack',
      description:
          'Beat the dealer to 21 without going over. Offers split, double down and insurance options.',
      heroImage: '',
      rtp: 98.0,
      minBet: 1.0,
      maxBet: 1000.0,
      tags: ['table game', 'skill', 'low house edge'],
    ),
  };

  // Promotional offers displayed on the lobby.
  final List<Promotion> _promotions = [
    Promotion(
      id: 'welcome',
      title: 'Welcome Bonus',
      description: 'Deposit and get 100% bonus up to \$500 + 50 free spins!',
      imageUrl: '',
    ),
    Promotion(
      id: 'cashback',
      title: 'Weekly Cashback',
      description: 'Earn 10% cashback on your net losses every week.',
      imageUrl: '',
    ),
    Promotion(
      id: 'tournament',
      title: 'Slots Tournament',
      description: 'Compete for the top spot and win a share of \$10,000.',
      imageUrl: '',
    ),
  ];

  // Recent winners used in a marquee ticker.
  final List<Winner> _winners = [
    Winner(
        name: 'Alice',
        game: 'Slots',
        amount: 1200.0,
        date: DateTime.now().subtract(const Duration(hours: 2))),
    Winner(
        name: 'Bob',
        game: 'Roulette',
        amount: 800.0,
        date: DateTime.now().subtract(const Duration(hours: 4))),
    Winner(
        name: 'Carlos',
        game: 'Blackjack',
        amount: 1500.0,
        date: DateTime.now().subtract(const Duration(days: 1))),
  ];

  // Recommended games – currently reuse the same list of games but could be personalised.
  final List<Game> _recommended = [];

  // Bonuses and rewards.
  final List<Bonus> _bonuses = [
    Bonus(
      id: 'welcome',
      title: 'Welcome Package',
      description: 'Claim up to \$500 in bonus funds and 50 free spins.',
      progress: 1.0,
      claimable: true,
    ),
    Bonus(
      id: 'cashback',
      title: 'Weekly Cashback',
      description: 'Receive 10% cashback on net losses every Monday.',
      progress: 0.5,
      claimable: false,
    ),
    Bonus(
      id: 'free_spins',
      title: 'Free Spins Frenzy',
      description: 'Earn up to 100 free spins by wagering on slots.',
      progress: 0.2,
      claimable: false,
    ),
  ];

  // VIP information with tiers.
  VipInfo _vipInfo = VipInfo(
    currentTier: 'Silver',
    currentPoints: 1200,
    tiers: [
      VipTier(
          name: 'Bronze',
          requiredPoints: 0,
          description: 'Entry level tier with basic benefits.'),
      VipTier(
          name: 'Silver',
          requiredPoints: 1000,
          description: 'Unlock free spins and cashback perks.'),
      VipTier(
          name: 'Gold',
          requiredPoints: 5000,
          description: 'Enjoy higher limits and VIP bonuses.'),
      VipTier(
          name: 'Platinum',
          requiredPoints: 20000,
          description: 'Exclusive tournaments and premium rewards.'),
    ],
  );

  // Responsible gaming info; deposit limit and usage can be adjusted after each bet.
  ResponsibleGamingInfo _responsibleInfo = ResponsibleGamingInfo(
    dailyDepositLimit: 5000.0,
    usedDeposit: 0.0,
    sessionReminderEnabled: true,
    info:
        'Gambling should be entertaining. Remember to set limits and take breaks. Visit our Responsible Gaming page for tips on staying in control.',
  );

  // Internal list to track betting history.
  final List<BetHistoryItem> _betHistory = [];

  CasinoRepositoryImpl() {
    // Populate recommended games initially (excluding coming soon categories)
    _recommended.addAll(_games.where(
        (g) => g.id == 'slots' || g.id == 'roulette' || g.id == 'blackjack'));
  }

  // ----------------------------------------------------------------------
  // New API implementation
  @override
  Future<Result<CasinoLobbyData>> getLobbyData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final data = CasinoLobbyData(
      categories: ['Slots', 'Roulette', 'Blackjack', 'Poker', 'Live', 'Sports'],
      featuredGames: _games
          .where((g) =>
              g.id == 'slots' || g.id == 'roulette' || g.id == 'blackjack')
          .toList(),
      promotions: _promotions,
      recentWinners: _winners,
      recommendedGames: _recommended,
    );
    return Result.success(data);
  }

  @override
  Future<Result<GameDetail>> getGameDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final detail = _gameDetails[id];
    if (detail != null) {
      return Result.success(detail);
    } else {
      return Result.error('Game not found');
    }
  }

  BetHistoryItem _createBetResult(
      {required String gameId, required double bet}) {
    final gameName = _games.firstWhere((g) => g.id == gameId).name;
    final win = _rand.nextBool();
    double multiplier;
    switch (gameId) {
      case 'slots':
        multiplier = win ? (1.5 + _rand.nextDouble() * 3.0) : -1.0;
        break;
      case 'roulette':
        multiplier = win ? (2.0 + _rand.nextDouble() * 5.0) : -1.0;
        break;
      case 'blackjack':
        multiplier = win ? (1.5 + _rand.nextDouble() * 2.0) : -1.0;
        break;
      default:
        multiplier = win ? 1.0 : -1.0;
    }
    final payout = bet * multiplier;
    final result = win ? 'win' : 'loss';
    final item = BetHistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      gameName: gameName,
      gameType: gameId,
      betAmount: bet,
      payout: payout,
      date: DateTime.now(),
      result: result,
      status: 'completed',
    );
    _betHistory.add(item);
    // Update VIP points: 1 point per currency bet
    _vipInfo = VipInfo(
      currentTier: _vipInfo.currentTier,
      currentPoints: _vipInfo.currentPoints + bet.toInt(),
      tiers: _vipInfo.tiers,
    );
    // Update responsible gaming: accumulate used deposit for negative payouts
    if (payout < 0) {
      final newUsed = _responsibleInfo.usedDeposit + bet;
      _responsibleInfo = ResponsibleGamingInfo(
        dailyDepositLimit: _responsibleInfo.dailyDepositLimit,
        usedDeposit: newUsed,
        sessionReminderEnabled: _responsibleInfo.sessionReminderEnabled,
        info: _responsibleInfo.info,
      );
    }
    return item;
  }

  @override
  Future<Result<BetHistoryItem>> playSlots([double bet = 1.0]) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Result.success(_createBetResult(gameId: 'slots', bet: bet));
  }

  @override
  Future<Result<BetHistoryItem>> playRoulette(double bet) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Result.success(_createBetResult(gameId: 'roulette', bet: bet));
  }

  @override
  Future<Result<BetHistoryItem>> playBlackjack(double bet) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Result.success(_createBetResult(gameId: 'blackjack', bet: bet));
  }

  @override
  Future<Result<List<BetHistoryItem>>> getBetHistory() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final history = List<BetHistoryItem>.from(_betHistory);
    // Sort by date descending
    history.sort((a, b) => b.date.compareTo(a.date));
    return Result.success(history);
  }

  @override
  Future<Result<List<Bonus>>> getBonuses() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Result.success(List<Bonus>.from(_bonuses));
  }

  @override
  Future<Result<void>> claimBonus(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _bonuses.indexWhere((b) => b.id == id);
    if (index >= 0) {
      final bonus = _bonuses[index];
      // Only allow claiming if claimable
      if (bonus.claimable) {
        _bonuses[index] = Bonus(
          id: bonus.id,
          title: bonus.title,
          description: bonus.description,
          progress: bonus.progress,
          claimable: false,
        );
        return const Result.success(null);
      }
    }
    return Result.error('Bonus not claimable');
  }

  @override
  Future<Result<VipInfo>> getVipInfo() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Result.success(_vipInfo);
  }

  @override
  Future<Result<ResponsibleGamingInfo>> getResponsibleGamingInfo() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Result.success(_responsibleInfo);
  }

  // ----------------------------------------------------------------------
  // Legacy API implementation for backwards compatibility
  @override
  Future<Result<List<Game>>> getLobbyGames() async {
    final res = await getLobbyData();
    if (res is Success<CasinoLobbyData>) {
      return Result.success(res.value.featuredGames);
    } else {
      return Result.error((res as Error).message);
    }
  }

  @override
  Future<Result<GameHistoryItem>> playPoker() async {
    // Poker is deprecated; delegate to blackjack but override the game
    // name in the history record. Use a default bet of 1.0.
    final res = await playBlackjack(1.0);
    if (res is Success<BetHistoryItem>) {
      final item = res.value;
      // Create a copy with gameName set to Poker
      final pokerItem = BetHistoryItem(
        id: item.id,
        gameName: 'Poker',
        gameType: 'poker',
        betAmount: item.betAmount,
        payout: item.payout,
        date: item.date,
        result: item.result,
        status: item.status,
      );
      _betHistory.removeWhere((h) => h.id == item.id);
      _betHistory.add(pokerItem);
      return Result.success(pokerItem);
    } else {
      return Result.error((res as Error).message);
    }
  }

  @override
  Future<Result<List<GameHistoryItem>>> getHistory() async {
    final res = await getBetHistory();
    if (res is Success<List<BetHistoryItem>>) {
      return Result.success(res.value);
    } else {
      return Result.error((res as Error).message);
    }
  }
}
