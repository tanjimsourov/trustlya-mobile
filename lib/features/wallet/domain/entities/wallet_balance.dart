import 'token_balance.dart';

/// Overall wallet overview with total balance and list of token balances.
class WalletBalance {
  final double totalBalance;
  final List<TokenBalance> tokens;
  final String address;

  WalletBalance(
      {required this.totalBalance,
      required this.tokens,
      required this.address});
}
