import 'package:equatable/equatable.dart';

import 'investor_profile.dart';

/// Encapsulates the onboarding workflow for a single investor. Contains
/// references to the investor profile and current stage.
class OnboardingCase extends Equatable {
  final String id;
  final InvestorProfile investor;
  final OnboardingStatus status;
  final DateTime submittedAt;

  const OnboardingCase({
    required this.id,
    required this.investor,
    required this.status,
    required this.submittedAt,
  });

  @override
  List<Object?> get props => [id, investor, status, submittedAt];
}

/// Status of an onboarding case.
enum OnboardingStatus { awaitingReview, inReview, completed, rejected }
