import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/asset_detail.dart';
import '../../domain/repositories/wallet_repository.dart';
import 'withdraw_data.dart';
import 'withdraw_state.dart';

/// Cubit managing the withdraw workflow. Loads available networks and
/// estimates fees based on the selected network and amount. Also
/// performs the withdrawal using the [WalletRepository].
class WithdrawCubit extends Cubit<WithdrawState> {
  final WalletRepository _repository;
  WithdrawCubit(this._repository) : super(const WithdrawState());

  /// Initialises the withdrawal state for the given asset symbol.
  Future<void> init(String symbol) async {
    emit(state.copyWith(status: Status.loading));
    // Fetch networks and balance concurrently
    final networksRes = await _repository.getSupportedNetworks(symbol);
    final assetRes = await _repository.getAssetDetail(symbol);
    if (networksRes is Success<List<String>> &&
        assetRes is Success<AssetDetail>) {
      final networks = networksRes.value;
      final selected = networks.isNotEmpty ? networks.first : '';
      final balance = assetRes.value.amount;
      // Estimate fee for zero amount to initialise
      final feeRes = await _repository.estimateFee(symbol, selected, 0);
      double fee = 0;
      if (feeRes is Success<double>) fee = feeRes.value;
      final data = WithdrawData(
        symbol: symbol,
        networks: networks,
        selectedNetwork: selected,
        balance: balance,
        destination: '',
        amount: 0,
        fee: fee,
        submitted: false,
      );
      emit(state.copyWith(status: Status.success, data: data));
    } else {
      final msg = networksRes is Error
          ? networksRes.message
          : (assetRes is Error ? assetRes.message : 'Unknown error');
      emit(state.copyWith(status: Status.error, message: msg));
    }
  }

  /// Selects a network and re‑estimates the fee based on current amount.
  Future<void> selectNetwork(String network) async {
    final current = state.data;
    if (current == null) return;
    emit(state.copyWith(status: Status.loading));
    final feeRes =
        await _repository.estimateFee(current.symbol, network, current.amount);
    double fee = 0;
    if (feeRes is Success<double>) fee = feeRes.value;
    final data =
        current.copyWith(selectedNetwork: network, fee: fee, submitted: false);
    emit(state.copyWith(status: Status.success, data: data));
  }

  /// Updates the withdrawal amount and re‑estimates the fee. Does not
  /// perform validation on the amount; UI should handle invalid input.
  Future<void> updateAmount(double amount) async {
    final current = state.data;
    if (current == null) return;
    emit(state.copyWith(status: Status.loading));
    final feeRes = await _repository.estimateFee(
        current.symbol, current.selectedNetwork, amount);
    double fee = 0;
    if (feeRes is Success<double>) fee = feeRes.value;
    final data = current.copyWith(amount: amount, fee: fee, submitted: false);
    emit(state.copyWith(status: Status.success, data: data));
  }

  /// Updates the destination address.
  void updateDestination(String destination) {
    final current = state.data;
    if (current == null) return;
    final data = current.copyWith(destination: destination, submitted: false);
    emit(state.copyWith(data: data));
  }

  /// Performs the withdrawal. Emits loading and success/error states.
  Future<void> submit() async {
    final current = state.data;
    if (current == null) return;
    emit(state.copyWith(status: Status.loading));
    final res = await _repository.withdraw(current.symbol,
        current.selectedNetwork, current.destination, current.amount);
    if (res is Success<void>) {
      emit(state.copyWith(
          status: Status.success, data: current.copyWith(submitted: true)));
    } else if (res is Error<void>) {
      emit(state.copyWith(status: Status.error, message: res.message));
    }
  }
}
