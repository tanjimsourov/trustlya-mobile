import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/lifecycle_event.dart';

/// State for the lifecycle events page. Holds a list of events for a
/// particular tokenised programme.
class LifecycleEventsState extends BaseState<List<LifecycleEvent>?> {
  const LifecycleEventsState(
      {super.status = Status.initial, super.data, super.message});

  LifecycleEventsState copyWith(
      {Status? status, List<LifecycleEvent>? data, String? message}) {
    return LifecycleEventsState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
