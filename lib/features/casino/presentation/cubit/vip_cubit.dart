import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/vip_info.dart';
import '../../domain/repositories/casino_repository.dart';

/// State representing VIP/loyalty information.
class VipState extends BaseState<VipInfo?> {
  const VipState(
      {Status status = Status.initial, VipInfo? data, String? message})
      : super(status: status, data: data, message: message);

  VipState copyWith({Status? status, VipInfo? data, String? message}) {
    return VipState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}

/// Cubit to load VIP tiers and current loyalty status. It communicates
/// with the [CasinoRepository] to fetch [VipInfo].
class VipCubit extends Cubit<VipState> {
  final CasinoRepository _repository;
  VipCubit(this._repository) : super(const VipState());

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading));
    final res = await _repository.getVipInfo();
    if (res is Success<VipInfo>) {
      emit(state.copyWith(status: Status.success, data: res.value));
    } else if (res is Error<VipInfo>) {
      emit(state.copyWith(status: Status.error, message: res.message));
    }
  }
}
