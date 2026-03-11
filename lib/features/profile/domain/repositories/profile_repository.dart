import '../../../../core/utils/result.dart';
import '../entities/user_profile.dart';
import '../entities/security_settings.dart';
import '../entities/preferences.dart';

/// Contract for profile related operations.
abstract class ProfileRepository {
  Future<Result<UserProfile>> getProfile();
  Future<Result<UserProfile>> updateProfile(UserProfile profile);
  Future<Result<SecuritySettings>> getSecuritySettings();
  Future<Result<Preferences>> getPreferences();

  /// Attempts to change the user's password. Returns an empty success
  /// result on success or an error on failure.
  Future<Result<void>> changePassword(String oldPassword, String newPassword);

  /// Enables or disables two factor authentication depending on [enabled].
  /// Returns updated security settings on success.
  Future<Result<SecuritySettings>> toggleTwoFactor(bool enabled);

  /// Persists updated security settings. Allows changing auto logout
  /// duration, login alerts, trusted devices, etc.
  Future<Result<SecuritySettings>> updateSecuritySettings(
      SecuritySettings settings);
}
