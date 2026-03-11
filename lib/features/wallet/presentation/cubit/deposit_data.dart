/// Contains information required to display a deposit screen for a given
/// asset. Includes the asset symbol, available networks, the selected
/// network and the generated deposit address. It also holds an optional
/// recent deposit status string used to display pending deposits.
class DepositData {
  final String symbol;
  final List<String> networks;
  final String selectedNetwork;
  final String address;
  final String? recentStatus;

  const DepositData({
    required this.symbol,
    required this.networks,
    required this.selectedNetwork,
    required this.address,
    this.recentStatus,
  });

  DepositData copyWith({
    String? symbol,
    List<String>? networks,
    String? selectedNetwork,
    String? address,
    String? recentStatus,
  }) {
    return DepositData(
      symbol: symbol ?? this.symbol,
      networks: networks ?? this.networks,
      selectedNetwork: selectedNetwork ?? this.selectedNetwork,
      address: address ?? this.address,
      recentStatus: recentStatus ?? this.recentStatus,
    );
  }
}
