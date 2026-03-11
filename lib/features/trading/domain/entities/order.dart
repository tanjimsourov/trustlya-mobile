/// Represents a trade order.
class Order {
  final String id;
  final String assetSymbol;
  final double amount;
  final double price;
  final String type; // buy or sell
  final DateTime date;

  Order({
    required this.id,
    required this.assetSymbol,
    required this.amount,
    required this.price,
    required this.type,
    required this.date,
  });
}
