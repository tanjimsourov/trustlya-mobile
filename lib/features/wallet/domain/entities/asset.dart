/// Represents a cryptocurrency or token held in the user's wallet.
class Asset {
  final String symbol;
  final String name;
  final double amount;
  final double price;
  final double change24h; // percentage change over 24h

  const Asset({
    required this.symbol,
    required this.name,
    required this.amount,
    required this.price,
    required this.change24h,
  });

  /// The total value of this asset (amount * price).
  double get value => amount * price;
}
