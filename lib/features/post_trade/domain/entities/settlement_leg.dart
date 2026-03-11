import 'package:flutter/foundation.dart';

/// Possible statuses for a settlement leg. A leg may be matched
/// against its counterparty, unmatched (pending) or fully settled.
enum LegStatus { matched, unmatched, settled }

/// Represents a single leg of a settlement instruction. Each leg
/// details the accounts and amounts involved in settling a trade.
@immutable
class SettlementLeg {
  final String id;
  final String fromAccount;
  final String toAccount;
  final double amount;
  final String currency;
  final LegStatus status;

  const SettlementLeg({
    required this.id,
    required this.fromAccount,
    required this.toAccount,
    required this.amount,
    required this.currency,
    required this.status,
  });
}
