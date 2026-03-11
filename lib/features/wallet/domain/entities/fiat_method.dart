/// Represents a fiat on/off ramp method such as a card, bank or
/// regional payment option. Contains fee and processing time info.
class FiatMethod {
  final String provider;
  final String type; // card, bank, e-wallet, regional
  final double fee; // percentage fee expressed as a decimal
  final String processingTime; // e.g. "Instant", "1-3 business days"

  const FiatMethod({
    required this.provider,
    required this.type,
    required this.fee,
    required this.processingTime,
  });
}
