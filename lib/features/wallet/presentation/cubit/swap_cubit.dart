import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/asset_detail.dart';
import '../../domain/repositories/wallet_repository.dart';
import 'swap_data.dart';
import 'swap_state.dart';

/// Cubit for the swap/convert screen. Manages the selection of input
/// and output assets, calculates conversion rates and performs the
/// swap via the [WalletRepository].
class SwapCubit extends Cubit<SwapState> {
  final WalletRepository _repository;
  SwapCubit(this._repository) : super(const SwapState());

  /// Initialises the swap with default assets and zero amount.
  Future<void> init() async {
    emit(state.copyWith(status: Status.loading));
    // Choose the first two assets from the wallet as defaults
    final overviewRes = await _repository.getWalletOverview();
    if (overviewRes is Success) {
      final tokens = overviewRes.value.tokens;
      if (tokens.length >= 2) {
        final availableSymbols = tokens.map((token) => token.symbol).toList();
        final fromSymbol = tokens[0].symbol;
        final toSymbol = tokens[1].symbol;
        final data =
            await _calculateRate(fromSymbol, toSymbol, 0, availableSymbols);
        emit(state.copyWith(status: Status.success, data: data));
        return;
      }
    }
    emit(state.copyWith(
        status: Status.error, message: 'Not enough assets to swap'));
  }

  Future<SwapData> _calculateRate(
    String from,
    String to,
    double amount,
    List<String> availableSymbols, {
    bool submitted = false,
  }) async {
    // Fetch prices for both assets
    final fromRes = await _repository.getAssetDetail(from);
    final toRes = await _repository.getAssetDetail(to);
    double rate = 0;
    double toAmount = 0;
    if (fromRes is Success<AssetDetail> && toRes is Success<AssetDetail>) {
      final fromPrice = fromRes.value.price;
      final toPrice = toRes.value.price;
      if (toPrice != 0) {
        rate = fromPrice / toPrice;
        toAmount = amount * rate;
      }
    }
    return SwapData(
      fromSymbol: from,
      toSymbol: to,
      amount: amount,
      rate: rate,
      toAmount: toAmount,
      availableSymbols: availableSymbols,
      submitted: submitted,
    );
  }

  /// Updates the input asset and recalculates the rate.
  Future<void> updateFrom(String symbol) async {
    final current = state.data;
    if (current == null) return;
    emit(state.copyWith(status: Status.loading));
    final data = await _calculateRate(
        symbol, current.toSymbol, current.amount, current.availableSymbols);
    emit(state.copyWith(status: Status.success, data: data));
  }

  /// Updates the output asset and recalculates the rate.
  Future<void> updateTo(String symbol) async {
    final current = state.data;
    if (current == null) return;
    emit(state.copyWith(status: Status.loading));
    final data = await _calculateRate(
        current.fromSymbol, symbol, current.amount, current.availableSymbols);
    emit(state.copyWith(status: Status.success, data: data));
  }

  /// Updates the amount of the input asset and recalculates the target amount.
  Future<void> updateAmount(double amount) async {
    final current = state.data;
    if (current == null) return;
    emit(state.copyWith(status: Status.loading));
    final data = await _calculateRate(
        current.fromSymbol, current.toSymbol, amount, current.availableSymbols);
    emit(state.copyWith(status: Status.success, data: data));
  }

  /// Performs the swap operation through the repository.
  Future<void> swap() async {
    final current = state.data;
    if (current == null) return;
    emit(state.copyWith(status: Status.loading));
    final res = await _repository.swap(
        current.fromSymbol, current.toSymbol, current.amount);
    if (res is Success<void>) {
      final data = await _calculateRate(
        current.fromSymbol,
        current.toSymbol,
        current.amount,
        current.availableSymbols,
        submitted: true,
      );
      emit(state.copyWith(status: Status.success, data: data));
    } else if (res is Error<void>) {
      emit(state.copyWith(status: Status.error, message: res.message));
    }
  }
}
