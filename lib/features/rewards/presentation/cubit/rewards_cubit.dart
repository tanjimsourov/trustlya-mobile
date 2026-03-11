import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/mission.dart';
import '../../domain/repositories/rewards_repository.dart';
import 'rewards_state.dart';

/// Cubit managing the list of missions and claiming rewards. It
/// exposes a [RewardsState] which includes the mission list and
/// handles claim actions.
class RewardsCubit extends Cubit<RewardsState> {
  final RewardsRepository _repository;

  RewardsCubit(this._repository)
      : super(const RewardsState(status: Status.loading)) {
    load();
  }

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading));
    final res = await _repository.getMissions();
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

  Future<void> claim(String id) async {
    final res = await _repository.claimReward(id);
    res.when(
      success: (mission) async {
        // reload missions to update claimed status
        await load();
      },
      error: (msg) {
        emit(state.copyWith(status: Status.error, message: msg));
      },
    );
  }
}
