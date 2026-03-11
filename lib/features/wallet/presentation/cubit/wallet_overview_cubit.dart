import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/wallet_balance.dart';
import '../../domain/entities/wallet_transaction.dart';
import '../../domain/repositories/wallet_repository.dart';
import 'wallet_overview_data.dart';
import 'wallet_overview_state.dart';

/// Cubit that loads the wallet overview including total balance and recent
/// transactions. Uses [WalletRepository] to fetch data.
class WalletOverviewCubit extends Cubit<WalletOverviewState> {
  final WalletRepository _repository;
  WalletOverviewCubit(this._repository) : super(const WalletOverviewState());

  Future<void> loadOverview() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getWalletOverview();
    if (result is Success<WalletBalance>) {
      // Load recent transactions as well
      final txResult = await _repository.getWalletTransactionHistory();
      List<WalletTransaction> recent = [];
      if (txResult is Success<List<WalletTransaction>>) {
        recent = List<WalletTransaction>.from(txResult.value);
        // Sort by date descending and take the latest three
        recent.sort((a, b) => b.date.compareTo(a.date));
        if (recent.length > 3) recent = recent.sublist(0, 3);
      }
      emit(state.copyWith(
          status: Status.success,
          data: WalletOverviewData(
              balance: result.value, recentTransactions: recent)));
    } else if (result is Error<WalletBalance>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
