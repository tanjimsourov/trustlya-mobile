import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/repositories/carbon_repository.dart';
import 'achievements_state.dart';

/// Cubit for loading eco achievements and badges. Uses the repository
/// to compute progress based on total offsets.
class AchievementsCubit extends Cubit<AchievementsState> {
  final CarbonRepository _repository;
  AchievementsCubit(this._repository) : super(const AchievementsState());

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getAchievements();
    if (result is Success<List<Achievement>>) {
      final list = result.value;
      emit(state.copyWith(
          status: list.isEmpty ? Status.empty : Status.success, data: list));
    } else if (result is Error<List<Achievement>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
