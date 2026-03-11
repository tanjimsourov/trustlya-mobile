/// Represents a carbon offset project listed in the marketplace. Each
/// project includes metadata used on both the project card and
/// detailed views.
class CarbonProject {
  final String id;
  final String name;
  final String location;
  final List<String> badges; // registry or verification badges
  final double pricePerCredit;
  final String category;
  final String imageUrl;

  CarbonProject({
    required this.id,
    required this.name,
    required this.location,
    required this.badges,
    required this.pricePerCredit,
    required this.category,
    required this.imageUrl,
  });
}
