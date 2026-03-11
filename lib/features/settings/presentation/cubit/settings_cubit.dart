import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/general_settings.dart';
import '../../domain/entities/privacy_settings.dart';
import '../../domain/entities/theme_option.dart';
import '../../domain/entities/language_option.dart';
import '../../domain/repositories/settings_repository.dart';
import 'settings_state.dart';

/// Cubit for managing application settings.
class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _repository;
  SettingsCubit(this._repository) : super(const SettingsState());

  Future<void> loadGeneralSettings() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getGeneralSettings();
    if (result is Success<GeneralSettings>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<GeneralSettings>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> loadPrivacySettings() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getPrivacySettings();
    if (result is Success<PrivacySettings>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<PrivacySettings>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> loadThemeOptions() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getThemeOptions();
    if (result is Success<List<ThemeOption>>) {
      final list = result.value;
      emit(state.copyWith(
          status: list.isEmpty ? Status.empty : Status.success, data: list));
    } else if (result is Error<List<ThemeOption>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> loadLanguageOptions() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getLanguageOptions();
    if (result is Success<List<LanguageOption>>) {
      final list = result.value;
      emit(state.copyWith(
          status: list.isEmpty ? Status.empty : Status.success, data: list));
    } else if (result is Error<List<LanguageOption>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
