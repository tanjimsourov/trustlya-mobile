import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';

/// State for settings feature.
class SettingsState extends BaseState<dynamic> {
  const SettingsState(
      {super.status = Status.initial, super.data, super.message});

  SettingsState copyWith({Status? status, dynamic data, String? message}) {
    return SettingsState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
