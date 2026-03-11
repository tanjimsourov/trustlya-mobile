import '../../../../core/utils/result.dart';
import '../entities/general_settings.dart';
import '../entities/privacy_settings.dart';
import '../entities/theme_option.dart';
import '../entities/language_option.dart';

/// Contract for settings operations.
abstract class SettingsRepository {
  Future<Result<GeneralSettings>> getGeneralSettings();
  Future<Result<PrivacySettings>> getPrivacySettings();
  Future<Result<List<ThemeOption>>> getThemeOptions();
  Future<Result<List<LanguageOption>>> getLanguageOptions();
}
