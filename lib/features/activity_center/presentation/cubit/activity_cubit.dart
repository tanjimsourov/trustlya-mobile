import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/repositories/activity_repository.dart';
import '../../domain/entities/activity_item.dart';
import 'activity_state.dart';

/// Cubit responsible for loading and managing the unified activity
/// centre timeline. It fetches events from the [ActivityRepository]
/// and exposes them via [ActivityState].
class ActivityCubit extends Cubit<ActivityState> {
  final ActivityRepository _repository;

  ActivityCubit(this._repository)
      : super(const ActivityState(status: Status.loading)) {
    load();
  }

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading));
    final res = await _repository.getActivities();
    res.when(
      success: (data) {
        emit(state.copyWith(
            status: data.isEmpty ? Status.empty : Status.success, data: data));
      },
      error: (msg) {
        emit(state.copyWith(status: Status.error, message: msg));
      },
    );
  }
}
