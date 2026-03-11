/// Security settings for the user.
import 'trusted_device.dart';

/// Security settings for the user. In addition to two‑factor and
/// biometric settings this class tracks when the password was last
/// changed, a list of trusted devices, whether login alerts are
/// enabled, automatic logout duration and available backup methods.
class SecuritySettings {
  final bool twoFactorEnabled;
  final bool biometricEnabled;
  final DateTime passwordLastChanged;
  final List<TrustedDevice> trustedDevices;
  final bool loginAlertsEnabled;
  final Duration autoLogoutDuration;
  final List<String> backupMethods;

  SecuritySettings({
    required this.twoFactorEnabled,
    required this.biometricEnabled,
    required this.passwordLastChanged,
    required this.trustedDevices,
    required this.loginAlertsEnabled,
    required this.autoLogoutDuration,
    required this.backupMethods,
  });

  /// Returns a copy with modified fields.
  SecuritySettings copyWith({
    bool? twoFactorEnabled,
    bool? biometricEnabled,
    DateTime? passwordLastChanged,
    List<TrustedDevice>? trustedDevices,
    bool? loginAlertsEnabled,
    Duration? autoLogoutDuration,
    List<String>? backupMethods,
  }) {
    return SecuritySettings(
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      passwordLastChanged: passwordLastChanged ?? this.passwordLastChanged,
      trustedDevices: trustedDevices ?? this.trustedDevices,
      loginAlertsEnabled: loginAlertsEnabled ?? this.loginAlertsEnabled,
      autoLogoutDuration: autoLogoutDuration ?? this.autoLogoutDuration,
      backupMethods: backupMethods ?? this.backupMethods,
    );
  }
}
