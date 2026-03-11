/// Represents a recent winner in the casino. Used for ticker displays on the lobby.
class Winner {
  final String name;
  final String game;
  final double amount;
  final DateTime date;

  Winner({
    required this.name,
    required this.game,
    required this.amount,
    required this.date,
  });
}
