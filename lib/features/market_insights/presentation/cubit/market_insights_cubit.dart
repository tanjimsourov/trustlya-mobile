import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/market_insights_data.dart';
import '../../domain/repositories/market_insights_repository.dart';
import 'market_insights_state.dart';

/// Cubit for the market insights page. Loads top movers, volatility
/// lists and educational blurbs from the repository.
class MarketInsightsCubit extends Cubit<MarketInsightsState> {
  final MarketInsightsRepository _repository;

  MarketInsightsCubit(this._repository)
      : super(const MarketInsightsState(status: Status.loading)) {
    load();
  }

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading));
    final moversRes = await _repository.getTopMovers();
    final volRes = await _repository.getVolatility();
    final blurbsRes = await _repository.getEducationalBlurbs();
    if (moversRes.isError) {
      emit(state.copyWith(status: Status.error, message: moversRes.message));
      return;
    }
    if (volRes.isError) {
      emit(state.copyWith(status: Status.error, message: volRes.message));
      return;
    }
    if (blurbsRes.isError) {
      emit(state.copyWith(status: Status.error, message: blurbsRes.message));
      return;
    }
    final data = MarketInsightsData(
      topMovers: moversRes.value,
      volatility: volRes.value,
      blurbs: blurbsRes.value,
    );
    emit(state.copyWith(status: Status.success, data: data));
  }
}
