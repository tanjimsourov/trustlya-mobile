import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/referral_data.dart';
import '../../domain/repositories/referral_repository.dart';
import 'referral_state.dart';

/// Cubit managing referral data and invite actions.
class ReferralCubit extends Cubit<ReferralState> {
  final ReferralRepository _repository;

  ReferralCubit(this._repository)
      : super(const ReferralState(status: Status.loading)) {
    load();
  }

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading));
    final res = await _repository.getReferralData();
    res.when(
      success: (data) =>
          emit(state.copyWith(status: Status.success, data: data)),
      error: (msg) => emit(state.copyWith(status: Status.error, message: msg)),
    );
  }

  Future<void> invite(String name) async {
    final res = await _repository.invite(name);
    res.when(
      success: (data) =>
          emit(state.copyWith(status: Status.success, data: data)),
      error: (msg) => emit(state.copyWith(status: Status.error, message: msg)),
    );
  }
}
