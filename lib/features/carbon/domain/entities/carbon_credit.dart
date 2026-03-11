/// Represents a carbon credit in the marketplace.
class CarbonCredit {
  final String id;
  final String name;
  final double price;
  final double availableQuantity;

  CarbonCredit({
    required this.id,
    required this.name,
    required this.price,
    required this.availableQuantity,
  });
}
