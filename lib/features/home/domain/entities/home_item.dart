/// Trending asset or item for the home screen.
class HomeItem {
  final String id;
  final String name;
  final double price;
  final double change24h;

  HomeItem({
    required this.id,
    required this.name,
    required this.price,
    required this.change24h,
  });
}
