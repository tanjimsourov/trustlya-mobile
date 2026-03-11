import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/asset_detail.dart';
import '../../domain/entities/wallet_transaction.dart';
import '../../domain/repositories/wallet_repository.dart';
import 'asset_detail_state.dart';

/// Cubit responsible for loading details of a single asset and its recent
/// transactions. Uses [WalletRepository] to fetch data.
class AssetDetailCubit extends Cubit<AssetDetailState> {
  final WalletRepository _repository;
  AssetDetailCubit(this._repository) : super(const AssetDetailState());

  Future<void> load(String symbol) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getAssetDetail(symbol);
    if (result is Success<AssetDetail>) {
      // Load recent transactions for this symbol
      final txResult = await _repository.getWalletTransactionHistory();
      List<WalletTransaction> recent = [];
      if (txResult is Success<List<WalletTransaction>>) {
        recent = txResult.value
            .where((tx) =>
                tx.symbol == symbol.toUpperCase() ||
                tx.symbol.startsWith(symbol.toUpperCase() + '/'))
            .toList();
        recent.sort((a, b) => b.date.compareTo(a.date));
        if (recent.length > 5) recent = recent.sublist(0, 5);
      }
      emit(state.copyWith(
          status: Status.success,
          data: result.value,
          recentTransactions: recent));
    } else if (result is Error<AssetDetail>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
