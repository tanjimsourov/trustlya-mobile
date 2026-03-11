import 'asset.dart';

/// Detailed information about an asset including historical price data.
class AssetDetail extends Asset {
  /// Seven day price history relative to the current price. The list
  /// should contain values normalised between 0 and 1.
  final List<double> history;

  const AssetDetail({
    required String symbol,
    required String name,
    required double amount,
    required double price,
    required double change24h,
    required this.history,
  }) : super(
            symbol: symbol,
            name: name,
            amount: amount,
            price: price,
            change24h: change24h);
}
