import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';

/// State for carbon credit feature.
class CarbonState extends BaseState<dynamic> {
  const CarbonState({super.status = Status.initial, super.data, super.message});

  CarbonState copyWith({Status? status, dynamic data, String? message}) {
    return CarbonState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
