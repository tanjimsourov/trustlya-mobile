/// Represents a single tier in the VIP/loyalty ladder.
class VipTier {
  final String name;
  final int requiredPoints;
  final String description;

  VipTier({
    required this.name,
    required this.requiredPoints,
    required this.description,
  });
}

/// Holds information about the user’s current VIP status and available tiers.
class VipInfo {
  final String currentTier;
  final int currentPoints;
  final List<VipTier> tiers;

  VipInfo({
    required this.currentTier,
    required this.currentPoints,
    required this.tiers,
  });
}
