import '../../../../core/utils/result.dart';
import '../entities/kyc_status.dart';

/// Contract for KYC operations.
abstract class KycRepository {
  Future<Result<void>> startKyc();
  Future<Result<void>> uploadIdentity(String documentPath);
  Future<Result<void>> uploadDocument(String documentPath);
  Future<Result<KycStatus>> getStatus();
}
