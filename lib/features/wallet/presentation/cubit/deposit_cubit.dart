import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../../domain/entities/wallet_transaction.dart';
import 'deposit_data.dart';
import 'deposit_state.dart';

/// Cubit to manage the deposit flow. Loads supported networks and
/// generates deposit addresses for the selected asset.
class DepositCubit extends Cubit<DepositState> {
  final WalletRepository _repository;
  DepositCubit(this._repository) : super(const DepositState());

  /// Initialises deposit data for the given asset symbol.
  Future<void> load(String symbol) async {
    emit(state.copyWith(status: Status.loading));
    final networksRes = await _repository.getSupportedNetworks(symbol);
    if (networksRes is Success<List<String>>) {
      final networks = networksRes.value;
      final selected = networks.isNotEmpty ? networks.first : '';
      final addressRes = await _repository.getDepositAddress(symbol, selected);
      if (addressRes is Success<String>) {
        final data = DepositData(
            symbol: symbol,
            networks: networks,
            selectedNetwork: selected,
            address: addressRes.value);
        emit(state.copyWith(status: Status.success, data: data));
      } else if (addressRes is Error<String>) {
        emit(state.copyWith(status: Status.error, message: addressRes.message));
      }
    } else if (networksRes is Error<List<String>>) {
      emit(state.copyWith(status: Status.error, message: networksRes.message));
    }
  }

  /// Selects a different network for deposit and regenerates the address.
  Future<void> selectNetwork(String network) async {
    final current = state.data;
    if (current == null) return;
    emit(state.copyWith(status: Status.loading));
    final res = await _repository.getDepositAddress(current.symbol, network);
    if (res is Success<String>) {
      final data =
          current.copyWith(selectedNetwork: network, address: res.value);
      emit(state.copyWith(status: Status.success, data: data));
    } else if (res is Error<String>) {
      emit(state.copyWith(status: Status.error, message: res.message));
    }
  }
}
