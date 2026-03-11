import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/onboarding_case.dart';

/// State for the investor onboarding queue page. Holds pending and
/// in-progress onboarding cases.
class InvestorQueueState extends BaseState<List<OnboardingCase>?> {
  const InvestorQueueState(
      {super.status = Status.initial, super.data, super.message});

  InvestorQueueState copyWith(
      {Status? status, List<OnboardingCase>? data, String? message}) {
    return InvestorQueueState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
