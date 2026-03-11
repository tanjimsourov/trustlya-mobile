import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/wallet_transaction.dart';
import '../../domain/repositories/wallet_repository.dart';
import 'transaction_history_state.dart';

/// Cubit responsible for loading transaction history and applying filters.
class TransactionHistoryCubit extends Cubit<TransactionHistoryState> {
  final WalletRepository _repository;
  TransactionHistoryCubit(this._repository)
      : super(const TransactionHistoryState());

  Future<void> load({String? filter}) async {
    emit(state.copyWith(status: Status.loading, filter: filter));
    final res = await _repository.getWalletTransactionHistory(type: filter);
    if (res is Success<List<WalletTransaction>>) {
      final data = res.value;
      emit(state.copyWith(
          status: data.isEmpty ? Status.empty : Status.success, data: data));
    } else if (res is Error<List<WalletTransaction>>) {
      emit(state.copyWith(status: Status.error, message: res.message));
    }
  }
}
