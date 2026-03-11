/// Represents a tradable game item. Each item belongs to a game and has
/// metadata such as rarity, wear (float) and current price. The
/// `imageUrl` is used to display artwork in the UI.
class Item {
  final String id;
  final String game;
  final String name;
  final String rarity;
  final double wear;
  final double price;
  final String imageUrl;

  Item({
    required this.id,
    required this.game,
    required this.name,
    required this.rarity,
    required this.wear,
    required this.price,
    required this.imageUrl,
  });

  Item copyWith({
    String? id,
    String? game,
    String? name,
    String? rarity,
    double? wear,
    double? price,
    String? imageUrl,
  }) {
    return Item(
      id: id ?? this.id,
      game: game ?? this.game,
      name: name ?? this.name,
      rarity: rarity ?? this.rarity,
      wear: wear ?? this.wear,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
