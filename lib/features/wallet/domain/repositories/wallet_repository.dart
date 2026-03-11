import '../../../../core/utils/result.dart';
import '../entities/wallet_balance.dart';
import '../entities/asset_detail.dart';
import '../entities/wallet_transaction.dart';
import '../entities/linked_method.dart';
import '../entities/fiat_method.dart';
import '../entities/transaction.dart' as wallet_tx;

/// Contract for wallet operations.
abstract class WalletRepository {
  Future<Result<WalletBalance>> getWalletOverview();
  Future<Result<List<wallet_tx.Transaction>>> getTransactionHistory();

  /// Sends a token to another address. Equivalent to withdrawing funds.
  Future<Result<void>> send(String to, String symbol, double amount);

  /// Generates a receive address for the default token (deprecated).
  Future<Result<String>> receive();

  /// Returns a detailed view of a single asset.
  Future<Result<AssetDetail>> getAssetDetail(String symbol);

  /// Returns the supported networks for a given asset symbol (e.g. Ethereum, Solana).
  Future<Result<List<String>>> getSupportedNetworks(String symbol);

  /// Returns a deposit address for the given asset and network.
  Future<Result<String>> getDepositAddress(String symbol, String network);

  /// Executes a withdrawal to a destination address on a given network.
  Future<Result<void>> withdraw(
      String symbol, String network, String address, double amount);

  /// Estimates the fee for withdrawing a given amount on a network.
  Future<Result<double>> estimateFee(
      String symbol, String network, double amount);

  /// Swaps one asset for another. The repository will update balances accordingly.
  Future<Result<void>> swap(String fromSymbol, String toSymbol, double amount);

  /// Returns the wallet's transaction history. Optionally filter by type (deposit, withdraw, swap, buy, sell).
  Future<Result<List<WalletTransaction>>> getWalletTransactionHistory(
      {String? type});

  /// Returns the available fiat on/off ramp methods.
  Future<Result<List<FiatMethod>>> getFiatMethods();

  /// Returns the user's linked payout methods.
  Future<Result<List<LinkedMethod>>> getLinkedMethods();

  /// Adds a new linked payout method.
  Future<Result<void>> addLinkedMethod(LinkedMethod method);

  /// Removes a linked payout method by id.
  Future<Result<void>> removeLinkedMethod(String id);
}
