import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/referral_data.dart';

/// State for the referral page. Holds a [ReferralData] instance and
/// uses [BaseState] statuses for error and loading handling.
class ReferralState extends BaseState<ReferralData> {
  const ReferralState({required super.status, super.data, super.message});

  ReferralState copyWith({
    Status? status,
    ReferralData? data,
    String? message,
  }) {
    return ReferralState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
