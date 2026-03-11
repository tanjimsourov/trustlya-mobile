import 'package:equatable/equatable.dart';

/// Represents an investor participating in tokenized asset programs. Each
/// investor has basic contact and investment details.
class InvestorProfile extends Equatable {
  final String id;
  final String name;
  final String organization;
  final String country;
  final double committedAmount;
  final InvestorStatus status;

  const InvestorProfile({
    required this.id,
    required this.name,
    required this.organization,
    required this.country,
    required this.committedAmount,
    required this.status,
  });

  @override
  List<Object?> get props =>
      [id, name, organization, country, committedAmount, status];
}

/// KYC and onboarding status of an investor.
enum InvestorStatus { pending, approved, rejected }
