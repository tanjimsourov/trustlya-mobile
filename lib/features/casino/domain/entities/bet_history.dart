/// Represents a record of a bet placed by the user in the casino. Unlike
/// [GameHistoryItem] which was limited to slots and poker results, this
/// entity captures additional metadata such as the game type and payout.
class BetHistoryItem {
  final String id;
  final String gameName;
  final String gameType; // e.g. slots, roulette, blackjack
  final double betAmount;
  final double payout;
  final DateTime date;
  final String result; // win or loss
  final String status; // completed, pending, cancelled etc.

  BetHistoryItem({
    required this.id,
    required this.gameName,
    required this.gameType,
    required this.betAmount,
    required this.payout,
    required this.date,
    required this.result,
    required this.status,
  });
}
