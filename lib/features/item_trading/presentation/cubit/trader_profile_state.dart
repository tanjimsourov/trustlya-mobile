import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/trader_profile.dart';

/// State for the trader profile page. Holds a [TraderProfile].
class TraderProfileState extends BaseState<TraderProfile> {
  const TraderProfileState(
      {Status status = Status.initial, TraderProfile? data, String? message})
      : super(status: status, data: data, message: message);

  TraderProfileState copyWith(
      {Status? status, TraderProfile? data, String? message}) {
    return TraderProfileState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
