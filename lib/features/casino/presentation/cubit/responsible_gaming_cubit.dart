import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/responsible_gaming_info.dart';
import '../../domain/repositories/casino_repository.dart';

/// State holding responsible gaming information such as deposit limits
/// and session reminder settings.
class ResponsibleGamingState extends BaseState<ResponsibleGamingInfo?> {
  const ResponsibleGamingState(
      {Status status = Status.initial,
      ResponsibleGamingInfo? data,
      String? message})
      : super(status: status, data: data, message: message);

  ResponsibleGamingState copyWith(
      {Status? status, ResponsibleGamingInfo? data, String? message}) {
    return ResponsibleGamingState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}

/// Cubit for loading and managing responsible gaming settings. Currently
/// only supports loading information; updating limits and reminders would
/// require additional repository methods.
class ResponsibleGamingCubit extends Cubit<ResponsibleGamingState> {
  final CasinoRepository _repository;
  ResponsibleGamingCubit(this._repository)
      : super(const ResponsibleGamingState());

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading));
    final res = await _repository.getResponsibleGamingInfo();
    if (res is Success<ResponsibleGamingInfo>) {
      emit(state.copyWith(status: Status.success, data: res.value));
    } else if (res is Error<ResponsibleGamingInfo>) {
      emit(state.copyWith(status: Status.error, message: res.message));
    }
  }
}
