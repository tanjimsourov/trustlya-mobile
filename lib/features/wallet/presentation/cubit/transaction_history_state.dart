import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/wallet_transaction.dart';

/// State for the transaction history page. Stores the list of
/// transactions and the current filter type.
class TransactionHistoryState extends BaseState<List<WalletTransaction>?> {
  final String? filter; // deposit, withdraw, swap, buy, sell or null

  const TransactionHistoryState({
    Status status = Status.initial,
    List<WalletTransaction>? data,
    String? message,
    this.filter,
  }) : super(status: status, data: data, message: message);

  TransactionHistoryState copyWith({
    Status? status,
    List<WalletTransaction>? data,
    String? message,
    String? filter,
  }) {
    return TransactionHistoryState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
      filter: filter ?? this.filter,
    );
  }
}
