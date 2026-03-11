import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/user.dart';

/// State for authentication flows. Extends [BaseState] with a [User] payload.
class AuthState extends BaseState<User?> {
  const AuthState({super.status = Status.initial, super.data, super.message});

  @override
  AuthState copyWith({Status? status, User? data, String? message}) {
    return AuthState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
