import 'package:flutter/foundation.dart';

/// Severity levels used to categorise settlement exceptions. The
/// severity communicates the urgency and potential impact of the
/// exception on downstream operations.
enum ExceptionSeverity { low, medium, high }

/// Describes an exception encountered during settlement. Exceptions
/// may be raised due to unmatched instructions, failed transfers or
/// other operational issues. They are associated with a specific
/// settlement instruction and can be resolved or unresolved.
@immutable
class SettlementException {
  final String id;
  final String instructionId;
  final ExceptionSeverity severity;
  final String description;
  final DateTime date;
  final bool resolved;

  const SettlementException({
    required this.id,
    required this.instructionId,
    required this.severity,
    required this.description,
    required this.date,
    required this.resolved,
  });
}
