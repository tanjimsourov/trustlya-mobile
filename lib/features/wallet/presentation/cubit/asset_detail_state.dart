import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/asset_detail.dart';
import '../../domain/entities/wallet_transaction.dart';

/// Holds detailed information about an asset and a list of its recent
/// transactions. Used by [AssetDetailCubit].
class AssetDetailState extends BaseState<AssetDetail?> {
  final List<WalletTransaction> recentTransactions;

  const AssetDetailState({
    Status status = Status.initial,
    AssetDetail? data,
    String? message,
    this.recentTransactions = const [],
  }) : super(status: status, data: data, message: message);

  AssetDetailState copyWith({
    Status? status,
    AssetDetail? data,
    String? message,
    List<WalletTransaction>? recentTransactions,
  }) {
    return AssetDetailState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
      recentTransactions: recentTransactions ?? this.recentTransactions,
    );
  }
}
