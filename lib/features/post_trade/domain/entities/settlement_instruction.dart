import 'package:flutter/foundation.dart';

import 'settlement_leg.dart';

/// High level status for a settlement instruction. It may sit in
/// the queue awaiting processing, be actively processing, settled
/// successfully or failed due to an exception.
enum SettlementStatus { queued, processing, settled, failed }

/// Represents an instruction to settle a financial trade. An
/// instruction aggregates one or more legs and contains contextual
/// information such as the counterparty, amount and currency.
@immutable
class SettlementInstruction {
  final String id;
  final String reference;
  final DateTime date;
  final SettlementStatus status;
  final double amount;
  final String currency;
  final String counterparty;
  final List<SettlementLeg> legs;

  const SettlementInstruction({
    required this.id,
    required this.reference,
    required this.date,
    required this.status,
    required this.amount,
    required this.currency,
    required this.counterparty,
    required this.legs,
  });
}
