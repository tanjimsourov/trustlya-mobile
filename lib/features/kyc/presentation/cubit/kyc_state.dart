import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';

/// State for KYC feature.
class KycState extends BaseState<dynamic> {
  const KycState({super.status = Status.initial, super.data, super.message});

  KycState copyWith({Status? status, dynamic data, String? message}) {
    return KycState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
