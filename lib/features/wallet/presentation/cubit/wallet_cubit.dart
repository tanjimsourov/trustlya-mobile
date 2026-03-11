import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/wallet_balance.dart';
import '../../domain/entities/transaction.dart' as wallet_tx;
import '../../domain/repositories/wallet_repository.dart';
import 'wallet_state.dart';

/// Cubit for wallet operations.
class WalletCubit extends Cubit<WalletState> {
  final WalletRepository _repository;
  WalletCubit(this._repository) : super(const WalletState());

  Future<void> loadWalletOverview() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getWalletOverview();
    if (result is Success<WalletBalance>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<WalletBalance>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> send(String to, String symbol, double amount) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.send(to, symbol, amount);
    if (result is Success<void>) {
      emit(state.copyWith(status: Status.success));
    } else if (result is Error<void>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> receive() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.receive();
    if (result is Success<String>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<String>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> loadTransactionHistory() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getTransactionHistory();
    if (result is Success<List<wallet_tx.Transaction>>) {
      final data = result.value;
      emit(state.copyWith(
          status: data.isEmpty ? Status.empty : Status.success, data: data));
    } else if (result is Error<List<wallet_tx.Transaction>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
