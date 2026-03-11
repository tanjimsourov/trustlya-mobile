import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import 'wallet_overview_data.dart';

/// State for the wallet overview. Holds a [WalletOverviewData] containing
/// the balance and recent transactions.
class WalletOverviewState extends BaseState<WalletOverviewData?> {
  const WalletOverviewState(
      {Status status = Status.initial,
      WalletOverviewData? data,
      String? message})
      : super(status: status, data: data, message: message);

  WalletOverviewState copyWith(
      {Status? status, WalletOverviewData? data, String? message}) {
    return WalletOverviewState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
