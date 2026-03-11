/// Represents a carbon credit transaction.
class CarbonTransaction {
  final String id;
  final String projectName;
  final double quantity;
  final double pricePerCredit;
  final String type; // e.g. 'buy' or 'retire'
  final DateTime date;
  final String status; // e.g. 'completed', 'pending'

  CarbonTransaction({
    required this.id,
    required this.projectName,
    required this.quantity,
    required this.pricePerCredit,
    required this.type,
    required this.date,
    required this.status,
  });

  double get total => quantity * pricePerCredit;
}
