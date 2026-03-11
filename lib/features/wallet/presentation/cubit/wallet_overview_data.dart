import '../../domain/entities/wallet_balance.dart';
import '../../domain/entities/wallet_transaction.dart';

/// Container for wallet overview data including the overall balance and
/// a subset of recent transactions. Used by [WalletOverviewCubit].
class WalletOverviewData {
  final WalletBalance balance;
  final List<WalletTransaction> recentTransactions;

  const WalletOverviewData(
      {required this.balance, required this.recentTransactions});
}
