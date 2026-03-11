/// Represents a single market insight or trend. It can come from
/// various modules (crypto assets, game items, carbon projects). The
/// [name] identifies the asset/item/project, [type] indicates its
/// category (Asset, Item, Game, Carbon) and [change] reflects the
/// percentage movement. [value] can represent price or score.
class InsightItem {
  final String id;
  final String name;
  final String type;
  final double value;
  final double change; // percentage change over period
  final String extra; // e.g. volatility tag or description

  const InsightItem({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
    required this.change,
    this.extra = '',
  });
}
