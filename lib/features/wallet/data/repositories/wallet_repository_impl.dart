import 'dart:async';
import 'dart:math';

import '../../../../core/utils/result.dart';
import '../../domain/entities/asset_detail.dart';
import '../../domain/entities/asset.dart';
import '../../domain/entities/fiat_method.dart';
import '../../domain/entities/linked_method.dart';
import '../../domain/entities/token_balance.dart';
import '../../domain/entities/transaction.dart' as wallet_tx;
import '../../domain/entities/wallet_balance.dart';
import '../../domain/entities/wallet_transaction.dart';
import '../../domain/repositories/wallet_repository.dart';

abstract class WalletDataSource implements WalletRepository {}

class MockWalletDataSource implements WalletDataSource {
  final List<AssetDetail> _assets = [
    AssetDetail(
      symbol: 'BTC',
      name: 'Bitcoin',
      amount: 0.25,
      price: 45000.0,
      change24h: 2.3,
      history: _generateHistory(7),
    ),
    AssetDetail(
      symbol: 'ETH',
      name: 'Ethereum',
      amount: 2.0,
      price: 3000.0,
      change24h: -1.5,
      history: _generateHistory(7),
    ),
    AssetDetail(
      symbol: 'SOL',
      name: 'Solana',
      amount: 120.0,
      price: 40.0,
      change24h: 4.8,
      history: _generateHistory(7),
    ),
    AssetDetail(
      symbol: 'USDC',
      name: 'USD Coin',
      amount: 5000.0,
      price: 1.0,
      change24h: 0.0,
      history: _generateHistory(7),
    ),
  ];

  final Map<String, List<String>> _supportedNetworks = {
    'BTC': ['Bitcoin'],
    'ETH': ['Ethereum', 'Arbitrum', 'Polygon'],
    'SOL': ['Solana'],
    'USDC': ['Ethereum', 'Solana'],
  };

  final List<WalletTransaction> _walletTransactions = [];
  final String _baseAddress = '0x1234...abcd';

  final List<LinkedMethod> _linkedMethods = [
    LinkedMethod(
      id: '1',
      provider: 'Visa',
      type: 'card',
      maskedNumber: '**** **** **** 1234',
      isDefault: true,
      verified: true,
    ),
    LinkedMethod(
      id: '2',
      provider: 'BRAC Bank',
      type: 'bank',
      maskedNumber: '**** 7890',
      isDefault: false,
      verified: true,
    ),
  ];

  final List<FiatMethod> _fiatMethods = [
    FiatMethod(
        provider: 'Visa', type: 'card', fee: 0.03, processingTime: 'Instant'),
    FiatMethod(
        provider: 'MasterCard',
        type: 'card',
        fee: 0.03,
        processingTime: 'Instant'),
    FiatMethod(
        provider: 'Local Bank',
        type: 'bank',
        fee: 0.01,
        processingTime: '1-3 business days'),
    FiatMethod(
        provider: 'e-Wallet',
        type: 'e-wallet',
        fee: 0.02,
        processingTime: 'Instant'),
    FiatMethod(
        provider: 'Regional Payment',
        type: 'regional',
        fee: 0.02,
        processingTime: 'Instant'),
  ];

  @override
  Future<Result<WalletBalance>> getWalletOverview() async {
    await Future.delayed(const Duration(milliseconds: 800));
    final total = _assets.fold<double>(0, (sum, asset) => sum + asset.value);
    final tokens = _assets
        .map((asset) => TokenBalance(
              symbol: asset.symbol,
              amount: asset.amount,
              value: asset.value,
            ))
        .toList();
    return Result.success(
      WalletBalance(
        totalBalance: total,
        tokens: tokens,
        address: _baseAddress,
      ),
    );
  }

  @override
  Future<Result<void>> send(String to, String symbol, double amount) {
    return withdraw(
      symbol,
      _supportedNetworks[symbol]?.first ?? 'Ethereum',
      to,
      amount,
    );
  }

  @override
  Future<Result<String>> receive() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(_baseAddress);
  }

  @override
  Future<Result<List<wallet_tx.Transaction>>> getTransactionHistory() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final legacy = _walletTransactions
        .map((tx) => wallet_tx.Transaction(
              id: tx.id,
              type: tx.type,
              symbol: tx.symbol,
              amount: tx.amount,
              date: tx.date,
              counterparty: tx.destination ?? '',
            ))
        .toList();
    return Result.success(legacy);
  }

  @override
  Future<Result<AssetDetail>> getAssetDetail(String symbol) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return Result.success(
        _assets.firstWhere((asset) => asset.symbol == symbol.toUpperCase()),
      );
    } catch (_) {
      return const Result.error('Asset not found');
    }
  }

  @override
  Future<Result<List<String>>> getSupportedNetworks(String symbol) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Result.success(
      List<String>.from(
          _supportedNetworks[symbol.toUpperCase()] ?? ['Ethereum']),
    );
  }

  @override
  Future<Result<String>> getDepositAddress(
      String symbol, String network) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return Result.success(
      '$_baseAddress-${symbol.toUpperCase()}-${network.toLowerCase()}',
    );
  }

  @override
  Future<Result<void>> withdraw(
      String symbol, String network, String address, double amount) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final index =
          _assets.indexWhere((asset) => asset.symbol == symbol.toUpperCase());
      if (index < 0) {
        return const Result.error('Asset not found');
      }
      final asset = _assets[index];
      if (amount > asset.amount) {
        return const Result.error('Insufficient balance');
      }
      _assets[index] = AssetDetail(
        symbol: asset.symbol,
        name: asset.name,
        amount: asset.amount - amount,
        price: asset.price,
        change24h: asset.change24h,
        history: asset.history,
      );
      final fee = amount * 0.001;
      _walletTransactions.add(
        WalletTransaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'withdraw',
          symbol: symbol.toUpperCase(),
          amount: amount,
          fee: fee,
          date: DateTime.now(),
          network: network,
          destination: address,
          status: 'completed',
        ),
      );
      return const Result.success(null);
    } catch (error) {
      return Result.error(error.toString());
    }
  }

  @override
  Future<Result<double>> estimateFee(
      String symbol, String network, double amount) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final flat = 0.0005 * amount;
    return Result.success(amount * 0.001 + flat);
  }

  @override
  Future<Result<void>> swap(
      String fromSymbol, String toSymbol, double amount) async {
    await Future.delayed(const Duration(milliseconds: 700));
    try {
      final fromIndex = _assets
          .indexWhere((asset) => asset.symbol == fromSymbol.toUpperCase());
      final toIndex =
          _assets.indexWhere((asset) => asset.symbol == toSymbol.toUpperCase());
      if (fromIndex < 0 || toIndex < 0) {
        return const Result.error('Asset not found');
      }
      final fromAsset = _assets[fromIndex];
      final toAsset = _assets[toIndex];
      if (amount > fromAsset.amount) {
        return const Result.error('Insufficient balance');
      }

      final fromValue = amount * fromAsset.price;
      final toAmount = fromValue / toAsset.price;
      _assets[fromIndex] = AssetDetail(
        symbol: fromAsset.symbol,
        name: fromAsset.name,
        amount: fromAsset.amount - amount,
        price: fromAsset.price,
        change24h: fromAsset.change24h,
        history: fromAsset.history,
      );
      _assets[toIndex] = AssetDetail(
        symbol: toAsset.symbol,
        name: toAsset.name,
        amount: toAsset.amount + toAmount,
        price: toAsset.price,
        change24h: toAsset.change24h,
        history: toAsset.history,
      );
      _walletTransactions.add(
        WalletTransaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'swap',
          symbol: '${fromSymbol.toUpperCase()}/${toSymbol.toUpperCase()}',
          amount: amount,
          fee: 0.0,
          date: DateTime.now(),
          network: 'internal',
          destination: null,
          status: 'completed',
        ),
      );
      return const Result.success(null);
    } catch (error) {
      return Result.error(error.toString());
    }
  }

  @override
  Future<Result<List<WalletTransaction>>> getWalletTransactionHistory(
      {String? type}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (type == null) {
      return Result.success(List<WalletTransaction>.from(_walletTransactions));
    }
    return Result.success(
      _walletTransactions
          .where((transaction) => transaction.type == type)
          .toList(),
    );
  }

  @override
  Future<Result<List<FiatMethod>>> getFiatMethods() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Result.success(List<FiatMethod>.from(_fiatMethods));
  }

  @override
  Future<Result<List<LinkedMethod>>> getLinkedMethods() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Result.success(List<LinkedMethod>.from(_linkedMethods));
  }

  @override
  Future<Result<void>> addLinkedMethod(LinkedMethod method) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _linkedMethods.add(method);
    return const Result.success(null);
  }

  @override
  Future<Result<void>> removeLinkedMethod(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _linkedMethods.removeWhere((method) => method.id == id);
    return const Result.success(null);
  }
}

class WalletRepositoryImpl implements WalletRepository {
  WalletRepositoryImpl({WalletDataSource? dataSource})
      : _dataSource = dataSource ?? MockWalletDataSource();

  final WalletDataSource _dataSource;

  @override
  Future<Result<WalletBalance>> getWalletOverview() {
    return _dataSource.getWalletOverview();
  }

  @override
  Future<Result<List<wallet_tx.Transaction>>> getTransactionHistory() {
    return _dataSource.getTransactionHistory();
  }

  @override
  Future<Result<void>> send(String to, String symbol, double amount) {
    return _dataSource.send(to, symbol, amount);
  }

  @override
  Future<Result<String>> receive() {
    return _dataSource.receive();
  }

  @override
  Future<Result<AssetDetail>> getAssetDetail(String symbol) {
    return _dataSource.getAssetDetail(symbol);
  }

  @override
  Future<Result<List<String>>> getSupportedNetworks(String symbol) {
    return _dataSource.getSupportedNetworks(symbol);
  }

  @override
  Future<Result<String>> getDepositAddress(String symbol, String network) {
    return _dataSource.getDepositAddress(symbol, network);
  }

  @override
  Future<Result<void>> withdraw(
      String symbol, String network, String address, double amount) {
    return _dataSource.withdraw(symbol, network, address, amount);
  }

  @override
  Future<Result<double>> estimateFee(
      String symbol, String network, double amount) {
    return _dataSource.estimateFee(symbol, network, amount);
  }

  @override
  Future<Result<void>> swap(String fromSymbol, String toSymbol, double amount) {
    return _dataSource.swap(fromSymbol, toSymbol, amount);
  }

  @override
  Future<Result<List<WalletTransaction>>> getWalletTransactionHistory(
      {String? type}) {
    return _dataSource.getWalletTransactionHistory(type: type);
  }

  @override
  Future<Result<List<FiatMethod>>> getFiatMethods() {
    return _dataSource.getFiatMethods();
  }

  @override
  Future<Result<List<LinkedMethod>>> getLinkedMethods() {
    return _dataSource.getLinkedMethods();
  }

  @override
  Future<Result<void>> addLinkedMethod(LinkedMethod method) {
    return _dataSource.addLinkedMethod(method);
  }

  @override
  Future<Result<void>> removeLinkedMethod(String id) {
    return _dataSource.removeLinkedMethod(id);
  }
}

List<double> _generateHistory(int count) {
  final rng = Random();
  return List<double>.generate(count, (_) => 0.5 + rng.nextDouble() * 0.5);
}
