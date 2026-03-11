import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../domain/entities/post_trade_dashboard_data.dart';
import '../../domain/repositories/post_trade_repository.dart';
import '../../../../shared/cubit/base_state.dart';
import 'post_trade_dashboard_state.dart';

/// Cubit responsible for loading the post‑trade operations dashboard.
class PostTradeDashboardCubit extends Cubit<PostTradeDashboardState> {
  final PostTradeRepository _repository;
  PostTradeDashboardCubit(this._repository)
      : super(const PostTradeDashboardState());

  /// Fetches the dashboard data from the repository and updates
  /// the state accordingly. Emits loading, success or error states.
  Future<void> loadDashboard() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.fetchDashboard();
    if (result is Success<PostTradeDashboardData>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<PostTradeDashboardData>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
