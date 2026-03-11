import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';

/// State for profile feature.
class ProfileState extends BaseState<dynamic> {
  const ProfileState(
      {super.status = Status.initial, super.data, super.message});

  ProfileState copyWith({Status? status, dynamic data, String? message}) {
    return ProfileState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
