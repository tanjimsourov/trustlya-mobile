import 'item.dart';

/// Represents a trade between two parties. Holds lists of offered and
/// requested items along with metadata such as total values, counterparty
/// information and the trade status. Status can be 'pending',
/// 'completed' or 'cancelled'.
class Trade {
  final String id;
  final DateTime date;
  final List<Item> offered;
  final List<Item> requested;
  final double offeredValue;
  final double requestedValue;
  final String counterparty;
  final String status;

  Trade({
    required this.id,
    required this.date,
    required this.offered,
    required this.requested,
    required this.offeredValue,
    required this.requestedValue,
    required this.counterparty,
    required this.status,
  });
}
