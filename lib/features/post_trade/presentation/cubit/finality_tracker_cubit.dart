import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/cubit/base_state.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/finality_event.dart';
import '../../domain/repositories/post_trade_repository.dart';
import 'finality_tracker_state.dart';

/// Cubit managing finality event data. Provides a method to load all
/// events and update the state accordingly.
class FinalityTrackerCubit extends Cubit<FinalityTrackerState> {
  final PostTradeRepository _repository;
  FinalityTrackerCubit(this._repository) : super(const FinalityTrackerState());

  Future<void> loadEvents() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.fetchFinalityTracker();
    if (result is Success<List<FinalityEvent>>) {
      final list = result.value;
      if (list.isEmpty) {
        emit(state.copyWith(status: Status.empty, data: []));
      } else {
        emit(state.copyWith(status: Status.success, data: list));
      }
    } else if (result is Error<List<FinalityEvent>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
