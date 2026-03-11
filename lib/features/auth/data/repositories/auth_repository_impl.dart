import 'dart:async';

import '../../../../core/utils/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

abstract class AuthDataSource implements AuthRepository {}

class MockAuthDataSource implements AuthDataSource {
  @override
  Future<Result<User>> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return Result.success(User(id: '1', name: 'Demo User', email: email));
  }

  @override
  Future<Result<User>> register(
      String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return Result.success(User(id: '2', name: name, email: email));
  }

  @override
  Future<Result<void>> sendOtp(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    return const Result.success(null);
  }

  @override
  Future<Result<bool>> verifyOtp(String email, String otp) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return const Result.success(true);
  }

  @override
  Future<Result<void>> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const Result.success(null);
  }
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({AuthDataSource? dataSource})
      : _dataSource = dataSource ?? MockAuthDataSource();

  final AuthDataSource _dataSource;

  @override
  Future<Result<User>> login(String email, String password) {
    return _dataSource.login(email, password);
  }

  @override
  Future<Result<User>> register(String name, String email, String password) {
    return _dataSource.register(name, email, password);
  }

  @override
  Future<Result<void>> sendOtp(String email) {
    return _dataSource.sendOtp(email);
  }

  @override
  Future<Result<bool>> verifyOtp(String email, String otp) {
    return _dataSource.verifyOtp(email, otp);
  }

  @override
  Future<Result<void>> logout() {
    return _dataSource.logout();
  }
}
