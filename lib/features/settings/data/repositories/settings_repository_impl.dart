import 'dart:async';

import '../../../../core/utils/result.dart';
import '../../domain/entities/general_settings.dart';
import '../../domain/entities/language_option.dart';
import '../../domain/entities/privacy_settings.dart';
import '../../domain/entities/theme_option.dart';
import '../../domain/repositories/settings_repository.dart';

abstract class SettingsDataSource implements SettingsRepository {}

class MockSettingsDataSource implements SettingsDataSource {
  final GeneralSettings _general =
      GeneralSettings(notificationsEnabled: true, analyticsEnabled: true);
  final PrivacySettings _privacy =
      PrivacySettings(shareUsageData: false, personalizedAds: false);
  final List<ThemeOption> _themes = [
    ThemeOption(name: 'Light'),
    ThemeOption(name: 'Dark'),
  ];
  final List<LanguageOption> _languages = [
    LanguageOption(code: 'en', name: 'English'),
    LanguageOption(code: 'es', name: 'Spanish'),
    LanguageOption(code: 'fr', name: 'French'),
  ];

  @override
  Future<Result<GeneralSettings>> getGeneralSettings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(_general);
  }

  @override
  Future<Result<PrivacySettings>> getPrivacySettings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(_privacy);
  }

  @override
  Future<Result<List<ThemeOption>>> getThemeOptions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(_themes);
  }

  @override
  Future<Result<List<LanguageOption>>> getLanguageOptions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(_languages);
  }
}

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({SettingsDataSource? dataSource})
      : _dataSource = dataSource ?? MockSettingsDataSource();

  final SettingsDataSource _dataSource;

  @override
  Future<Result<GeneralSettings>> getGeneralSettings() {
    return _dataSource.getGeneralSettings();
  }

  @override
  Future<Result<PrivacySettings>> getPrivacySettings() {
    return _dataSource.getPrivacySettings();
  }

  @override
  Future<Result<List<ThemeOption>>> getThemeOptions() {
    return _dataSource.getThemeOptions();
  }

  @override
  Future<Result<List<LanguageOption>>> getLanguageOptions() {
    return _dataSource.getLanguageOptions();
  }
}
