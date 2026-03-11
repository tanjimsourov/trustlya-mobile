/// Holds all information necessary to perform a withdrawal. Includes
/// selected asset symbol, available networks, selected network, the
/// destination address, amount to withdraw and the estimated fee. The
/// `balance` field is provided for calculating the max amount.
class WithdrawData {
  final String symbol;
  final List<String> networks;
  final String selectedNetwork;
  final double balance;
  final String destination;
  final double amount;
  final double fee;
  final bool submitted;

  const WithdrawData({
    required this.symbol,
    required this.networks,
    required this.selectedNetwork,
    required this.balance,
    required this.destination,
    required this.amount,
    required this.fee,
    this.submitted = false,
  });

  WithdrawData copyWith({
    String? symbol,
    List<String>? networks,
    String? selectedNetwork,
    double? balance,
    String? destination,
    double? amount,
    double? fee,
    bool? submitted,
  }) {
    return WithdrawData(
      symbol: symbol ?? this.symbol,
      networks: networks ?? this.networks,
      selectedNetwork: selectedNetwork ?? this.selectedNetwork,
      balance: balance ?? this.balance,
      destination: destination ?? this.destination,
      amount: amount ?? this.amount,
      fee: fee ?? this.fee,
      submitted: submitted ?? this.submitted,
    );
  }
}
