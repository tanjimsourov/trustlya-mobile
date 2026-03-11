import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

/// Cubit responsible for authentication logic.
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  AuthCubit(this._repository) : super(const AuthState());

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.login(email, password);
    if (result is Success<User>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<User>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> register(String name, String email, String password) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.register(name, email, password);
    if (result is Success<User>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<User>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> sendOtp(String email) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.sendOtp(email);
    if (result is Success<void>) {
      emit(state.copyWith(status: Status.success));
    } else if (result is Error<void>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.verifyOtp(email, otp);
    if (result is Success<bool> && result.value) {
      emit(state.copyWith(status: Status.success));
    } else if (result is Error<bool>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.logout();
    if (result is Success<void>) {
      emit(const AuthState(status: Status.initial, data: null));
    } else if (result is Error<void>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
