import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/security_settings.dart';
import '../../domain/entities/preferences.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_state.dart';

/// Cubit for managing user profile data and settings.
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;
  ProfileCubit(this._repository) : super(const ProfileState());

  Future<void> loadProfile() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getProfile();
    if (result is Success<UserProfile>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<UserProfile>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.updateProfile(profile);
    if (result is Success<UserProfile>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<UserProfile>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> loadSecuritySettings() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getSecuritySettings();
    if (result is Success<SecuritySettings>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<SecuritySettings>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  /// Changes the user's password. Emits loading then either success or error.
  Future<void> changePassword(String oldPassword, String newPassword) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.changePassword(oldPassword, newPassword);
    if (result is Success<void>) {
      emit(state.copyWith(status: Status.success));
    } else if (result is Error<void>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  /// Toggles two factor authentication and emits the updated security settings.
  Future<void> toggleTwoFactor(bool enabled) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.toggleTwoFactor(enabled);
    if (result is Success<SecuritySettings>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<SecuritySettings>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  /// Persists updated security settings.
  Future<void> updateSecuritySettings(SecuritySettings settings) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.updateSecuritySettings(settings);
    if (result is Success<SecuritySettings>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<SecuritySettings>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> loadPreferences() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getPreferences();
    if (result is Success<Preferences>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<Preferences>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
