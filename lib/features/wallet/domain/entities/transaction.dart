/// Represents a wallet transaction.
class Transaction {
  final String id;
  final String type; // send or receive
  final String symbol;
  final double amount;
  final DateTime date;
  final String counterparty;

  Transaction({
    required this.id,
    required this.type,
    required this.symbol,
    required this.amount,
    required this.date,
    required this.counterparty,
  });
}
