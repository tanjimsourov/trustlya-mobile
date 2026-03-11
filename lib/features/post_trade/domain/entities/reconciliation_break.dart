import 'package:flutter/foundation.dart';

/// The resolution state of a reconciliation break. An unresolved
/// break indicates a mismatch that requires investigation. A
/// resolved break has been addressed and accounted for.
enum BreakStatus { unresolved, resolved }

/// Represents a reconciliation break discovered during the
/// post‑trade matching process. Breaks highlight differences between
/// expected and actual positions or cash movements.
@immutable
class ReconciliationBreak {
  final String id;
  final String type;
  final String description;
  final double amount;
  final String currency;
  final DateTime date;
  final BreakStatus status;

  const ReconciliationBreak({
    required this.id,
    required this.type,
    required this.description,
    required this.amount,
    required this.currency,
    required this.date,
    required this.status,
  });
}
