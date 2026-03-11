import 'dart:async';

import '../../../../core/utils/result.dart';
import '../../domain/entities/linked_account.dart';
import '../../domain/entities/preferences.dart';
import '../../domain/entities/security_settings.dart';
import '../../domain/entities/trusted_device.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

abstract class ProfileDataSource implements ProfileRepository {}

class MockProfileDataSource implements ProfileDataSource {
  UserProfile _profile = UserProfile(
    id: '1',
    name: 'Demo User',
    email: 'demo@trustlya.app',
    phone: '+123456789',
    avatarUrl: 'https://placehold.co/100x100',
    tier: 'Gold',
    verified: true,
    joinedDate: DateTime(2025, 3, 1),
    completion: 0.8,
    linkedAccounts: [
      LinkedAccount(provider: 'Google', username: 'demo@gmail.com'),
      LinkedAccount(provider: 'Steam', username: 'demoSteam'),
    ],
  );

  SecuritySettings _securitySettings = SecuritySettings(
    twoFactorEnabled: true,
    biometricEnabled: false,
    passwordLastChanged: DateTime.now().subtract(const Duration(days: 30)),
    trustedDevices: [
      TrustedDevice(
          name: 'iPhone 13',
          lastActive: DateTime.now().subtract(const Duration(hours: 2))),
      TrustedDevice(
          name: 'MacBook Pro',
          lastActive: DateTime.now().subtract(const Duration(days: 1))),
    ],
    loginAlertsEnabled: true,
    autoLogoutDuration: const Duration(minutes: 10),
    backupMethods: ['Email Recovery', 'SMS'],
  );

  Preferences _preferences = Preferences(language: 'en', theme: 'light');

  @override
  Future<Result<UserProfile>> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(_profile);
  }

  @override
  Future<Result<UserProfile>> updateProfile(UserProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _profile = profile;
    return Result.success(_profile);
  }

  @override
  Future<Result<SecuritySettings>> getSecuritySettings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(_securitySettings);
  }

  @override
  Future<Result<Preferences>> getPreferences() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(_preferences);
  }

  @override
  Future<Result<void>> changePassword(
      String oldPassword, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (newPassword.length < 6) {
      return Result.error('Password too short');
    }
    _securitySettings =
        _securitySettings.copyWith(passwordLastChanged: DateTime.now());
    return const Result.success(null);
  }

  @override
  Future<Result<SecuritySettings>> toggleTwoFactor(bool enabled) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _securitySettings = _securitySettings.copyWith(twoFactorEnabled: enabled);
    return Result.success(_securitySettings);
  }

  @override
  Future<Result<SecuritySettings>> updateSecuritySettings(
      SecuritySettings settings) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _securitySettings = settings;
    return Result.success(_securitySettings);
  }
}

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({ProfileDataSource? dataSource})
      : _dataSource = dataSource ?? MockProfileDataSource();

  final ProfileDataSource _dataSource;

  @override
  Future<Result<UserProfile>> getProfile() {
    return _dataSource.getProfile();
  }

  @override
  Future<Result<UserProfile>> updateProfile(UserProfile profile) {
    return _dataSource.updateProfile(profile);
  }

  @override
  Future<Result<SecuritySettings>> getSecuritySettings() {
    return _dataSource.getSecuritySettings();
  }

  @override
  Future<Result<Preferences>> getPreferences() {
    return _dataSource.getPreferences();
  }

  @override
  Future<Result<void>> changePassword(String oldPassword, String newPassword) {
    return _dataSource.changePassword(oldPassword, newPassword);
  }

  @override
  Future<Result<SecuritySettings>> toggleTwoFactor(bool enabled) {
    return _dataSource.toggleTwoFactor(enabled);
  }

  @override
  Future<Result<SecuritySettings>> updateSecuritySettings(
      SecuritySettings settings) {
    return _dataSource.updateSecuritySettings(settings);
  }
}
