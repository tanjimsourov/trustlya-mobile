/// Represents a user’s position in a carbon offset project. Each
/// holding includes the project identifier and name, quantity of
/// credits held, current price and a retired flag indicating whether
/// the credits have been permanently retired (i.e. offset).
class CarbonHolding {
  final String projectId;
  final String projectName;
  final double quantity;
  final double pricePerCredit;
  final bool retired;

  CarbonHolding({
    required this.projectId,
    required this.projectName,
    required this.quantity,
    required this.pricePerCredit,
    required this.retired,
  });

  double get value => quantity * pricePerCredit;

  CarbonHolding copyWith({
    String? projectId,
    String? projectName,
    double? quantity,
    double? pricePerCredit,
    bool? retired,
  }) {
    return CarbonHolding(
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      quantity: quantity ?? this.quantity,
      pricePerCredit: pricePerCredit ?? this.pricePerCredit,
      retired: retired ?? this.retired,
    );
  }
}
