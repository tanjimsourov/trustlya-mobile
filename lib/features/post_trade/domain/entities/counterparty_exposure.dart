import 'package:flutter/foundation.dart';

/// Risk levels associated with counterparty exposures. These map to
/// the likelihood of default or operational risk when engaging
/// counterparties in settlement and treasury movements.
enum RiskLevel { low, medium, high }

/// Represents the exposure to a particular counterparty measured in a
/// given currency. It includes the notional amount and the date at
/// which settlement or repayment is expected.
@immutable
class CounterpartyExposure {
  final String counterparty;
  final double exposure;
  final String currency;
  final DateTime settlementDate;
  final RiskLevel riskLevel;

  const CounterpartyExposure({
    required this.counterparty,
    required this.exposure,
    required this.currency,
    required this.settlementDate,
    required this.riskLevel,
  });
}
