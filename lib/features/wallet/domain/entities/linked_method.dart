/// Represents a linked bank account or card used for payouts/off‑ramp.
class LinkedMethod {
  final String id;
  final String provider;
  final String type; // card, bank, e-wallet
  final String maskedNumber;
  final bool isDefault;
  final bool verified;

  const LinkedMethod({
    required this.id,
    required this.provider,
    required this.type,
    required this.maskedNumber,
    this.isDefault = false,
    this.verified = true,
  });

  LinkedMethod copyWith({
    String? id,
    String? provider,
    String? type,
    String? maskedNumber,
    bool? isDefault,
    bool? verified,
  }) {
    return LinkedMethod(
      id: id ?? this.id,
      provider: provider ?? this.provider,
      type: type ?? this.type,
      maskedNumber: maskedNumber ?? this.maskedNumber,
      isDefault: isDefault ?? this.isDefault,
      verified: verified ?? this.verified,
    );
  }
}
