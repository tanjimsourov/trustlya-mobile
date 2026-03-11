import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/achievement.dart';

/// State for the achievements/badges page.
class AchievementsState extends BaseState<List<Achievement>?> {
  const AchievementsState(
      {super.status = Status.initial, super.data, super.message});

  AchievementsState copyWith(
      {Status? status, List<Achievement>? data, String? message}) {
    return AchievementsState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
