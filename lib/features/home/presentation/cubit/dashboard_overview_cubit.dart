import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/dashboard_overview.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/entities/home_item.dart';
import '../../domain/repositories/home_repository.dart';
import '../../../wallet/domain/entities/transaction.dart' as wallet_tx;
import '../../../wallet/domain/repositories/wallet_repository.dart';
import 'dashboard_overview_state.dart';

/// Aggregates multiple repositories to provide all of the data needed
/// for the home dashboard. This cubit fetches dashboard summary,
/// trending assets and recent transactions and emits a single
/// [DashboardOverview] object once everything has loaded.
class DashboardOverviewCubit extends Cubit<DashboardOverviewState> {
  final HomeRepository _homeRepository;
  final WalletRepository _walletRepository;
  DashboardOverviewCubit(this._homeRepository, this._walletRepository)
      : super(const DashboardOverviewState());

  /// Loads the dashboard summary, trending assets and recent
  /// transactions concurrently. If any of the operations fails a
  /// generic error message is emitted. Otherwise the combined
  /// [DashboardOverview] is emitted with a success status.
  Future<void> loadOverview() async {
    emit(state.copyWith(status: Status.loading));

    final dashboardResult = await _homeRepository.getDashboardData();
    final trendingResult = await _homeRepository.getTrendingAssets();
    final transactionResult = await _walletRepository.getTransactionHistory();

    // Unpack results and check for errors
    if (dashboardResult is Success<DashboardData> &&
        trendingResult is Success<List<HomeItem>> &&
        transactionResult is Success<List<wallet_tx.Transaction>>) {
      final overview = DashboardOverview(
        dashboard: dashboardResult.value,
        trending: trendingResult.value,
        transactions: transactionResult.value,
      );
      emit(state.copyWith(status: Status.success, data: overview));
    } else {
      emit(state.copyWith(
          status: Status.error, message: 'Failed to load dashboard'));
    }
  }
}
