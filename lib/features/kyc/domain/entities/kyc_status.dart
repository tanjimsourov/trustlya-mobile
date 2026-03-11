/// Represents the KYC verification status.
class KycStatus {
  final String status; // pending, approved, rejected
  final String message;

  KycStatus({required this.status, required this.message});
}
