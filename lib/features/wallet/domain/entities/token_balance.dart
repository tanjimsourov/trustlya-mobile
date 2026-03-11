/// Represents the balance of a particular token.
class TokenBalance {
  final String symbol;
  final double amount;
  final double value;

  TokenBalance(
      {required this.symbol, required this.amount, required this.value});
}
