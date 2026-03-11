import 'package:flutter/foundation.dart';

/// Represents an entry in the audit trail for post‑trade and
/// settlement operations. Audit records capture user actions and
/// system events for compliance and reporting purposes.
@immutable
class AuditRecord {
  final String id;
  final String entity;
  final String action;
  final DateTime timestamp;
  final String user;
  final String description;

  const AuditRecord({
    required this.id,
    required this.entity,
    required this.action,
    required this.timestamp,
    required this.user,
    required this.description,
  });
}
