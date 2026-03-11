/// Represents a stored payment method for the user. Supports cards, bank
/// accounts, e‑wallets and crypto bridges. Each method includes an id,
/// type to differentiate providers, provider name, a masked account
/// number or address, an optional expiry date and whether it is the
/// default method.
class PaymentMethod {
  final String id;
  final String type;
  final String provider;
  final String maskedNumber;
  final String expiryDate;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.provider,
    required this.maskedNumber,
    required this.expiryDate,
    required this.isDefault,
  });

  PaymentMethod copyWith({
    String? id,
    String? type,
    String? provider,
    String? maskedNumber,
    String? expiryDate,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      provider: provider ?? this.provider,
      maskedNumber: maskedNumber ?? this.maskedNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
