import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';

/// State for notifications feature.
class NotificationsState extends BaseState<dynamic> {
  const NotificationsState(
      {super.status = Status.initial, super.data, super.message});

  NotificationsState copyWith({Status? status, dynamic data, String? message}) {
    return NotificationsState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
