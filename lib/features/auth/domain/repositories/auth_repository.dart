import '../../../../core/utils/result.dart';
import '../entities/user.dart';

/// Contract for authentication operations.
abstract class AuthRepository {
  Future<Result<User>> login(String email, String password);
  Future<Result<User>> register(String name, String email, String password);
  Future<Result<void>> sendOtp(String email);
  Future<Result<bool>> verifyOtp(String email, String otp);
  Future<Result<void>> logout();
}
