import 'package:flutter/foundation.dart';

/// Represents a treasury cash or asset position. A position holds
/// balances across available, pending and total amounts for a given
/// account and currency.
@immutable
class TreasuryPosition {
  final String accountName;
  final String currency;
  final double balance;
  final double available;
  final double pending;

  const TreasuryPosition({
    required this.accountName,
    required this.currency,
    required this.balance,
    required this.available,
    required this.pending,
  });
}
