import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';

/// State for wallet feature.
class WalletState extends BaseState<dynamic> {
  const WalletState({super.status = Status.initial, super.data, super.message});

  WalletState copyWith({Status? status, dynamic data, String? message}) {
    return WalletState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
