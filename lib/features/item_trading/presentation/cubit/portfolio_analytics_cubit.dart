import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/portfolio_analytics.dart';
import '../../domain/repositories/item_trading_repository.dart';
import 'portfolio_analytics_state.dart';

/// Cubit that loads portfolio analytics for game items. It fetches
/// performance time series, rarity distribution, best performing
/// items and profit/loss summaries from the repository.
class PortfolioAnalyticsCubit extends Cubit<PortfolioAnalyticsState> {
  final ItemTradingRepository _repository;
  PortfolioAnalyticsCubit(this._repository)
      : super(const PortfolioAnalyticsState());

  Future<void> loadAnalytics() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getPortfolioAnalytics();
    if (result is Success<PortfolioAnalytics>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<PortfolioAnalytics>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
