import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/activity_item.dart';

/// State for the unified activity centre. Holds a list of
/// [ActivityItem]s and manages loading/error/empty statuses via
/// [BaseState].
class ActivityState extends BaseState<List<ActivityItem>> {
  const ActivityState({required super.status, super.data, super.message});

  ActivityState copyWith({
    Status? status,
    List<ActivityItem>? data,
    String? message,
  }) {
    return ActivityState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
