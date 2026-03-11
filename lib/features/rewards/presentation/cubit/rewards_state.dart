import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/mission.dart';

/// State for the rewards/missions page. Holds a list of [Mission]
/// objects and uses the [BaseState] statuses for loading and error
/// handling.
class RewardsState extends BaseState<List<Mission>> {
  const RewardsState({required super.status, super.data, super.message});

  RewardsState copyWith({
    Status? status,
    List<Mission>? data,
    String? message,
  }) {
    return RewardsState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
