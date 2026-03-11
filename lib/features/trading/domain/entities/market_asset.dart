/// Market asset for trading feature.
class MarketAsset {
  final String id;
  final String symbol;
  final String name;
  final double price;
  final double volume24h;

  MarketAsset({
    required this.id,
    required this.symbol,
    required this.name,
    required this.price,
    required this.volume24h,
  });
}
