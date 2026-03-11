/// Represents a transaction in the wallet. Types include deposit,
/// withdrawal, swap, buy or sell.
class WalletTransaction {
  final String id;
  final String type; // deposit, withdraw, swap, buy, sell
  final String symbol;
  final double amount;
  final double fee;
  final DateTime date;
  final String network;
  final String? destination;
  final String status; // pending, completed, failed

  const WalletTransaction({
    required this.id,
    required this.type,
    required this.symbol,
    required this.amount,
    required this.fee,
    required this.date,
    required this.network,
    this.destination,
    this.status = 'completed',
  });
}
