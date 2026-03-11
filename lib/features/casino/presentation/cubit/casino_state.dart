import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';

/// State for casino feature.
class CasinoState extends BaseState<dynamic> {
  const CasinoState({super.status = Status.initial, super.data, super.message});

  CasinoState copyWith({Status? status, dynamic data, String? message}) {
    return CasinoState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
