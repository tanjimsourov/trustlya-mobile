/// Data model for the swap/convert screen. Contains the selected
/// input and output assets, the amount to swap, the calculated rate
/// and the resulting amount of the target asset.
class SwapData {
  final String fromSymbol;
  final String toSymbol;
  final double amount;
  final double rate;
  final double toAmount;
  final List<String> availableSymbols;
  final bool submitted;

  const SwapData({
    required this.fromSymbol,
    required this.toSymbol,
    required this.amount,
    required this.rate,
    required this.toAmount,
    required this.availableSymbols,
    this.submitted = false,
  });

  SwapData copyWith({
    String? fromSymbol,
    String? toSymbol,
    double? amount,
    double? rate,
    double? toAmount,
    List<String>? availableSymbols,
    bool? submitted,
  }) {
    return SwapData(
      fromSymbol: fromSymbol ?? this.fromSymbol,
      toSymbol: toSymbol ?? this.toSymbol,
      amount: amount ?? this.amount,
      rate: rate ?? this.rate,
      toAmount: toAmount ?? this.toAmount,
      availableSymbols: availableSymbols ?? this.availableSymbols,
      submitted: submitted ?? this.submitted,
    );
  }
}
