import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/lifecycle_event.dart';
import '../../domain/repositories/tokenization_repository.dart';
import '../../../../core/utils/result.dart';
import 'lifecycle_events_state.dart';

/// Cubit for loading lifecycle events of a programme.
class LifecycleEventsCubit extends Cubit<LifecycleEventsState> {
  final TokenizationRepository _repository;
  LifecycleEventsCubit(this._repository) : super(const LifecycleEventsState());

  Future<void> loadEvents(String programId) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.fetchLifecycleEvents(programId);
    if (result is Success<List<LifecycleEvent>>) {
      final events = result.value;
      emit(state.copyWith(
          status: events.isEmpty ? Status.empty : Status.success,
          data: events));
    } else if (result is Error<List<LifecycleEvent>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
