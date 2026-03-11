import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/tokenization_activity_item.dart';

/// State for the tokenisation activity page. Contains recent activity
/// entries across all programmes.
class TokenizationActivityState
    extends BaseState<List<TokenizationActivityItem>?> {
  const TokenizationActivityState(
      {super.status = Status.initial, super.data, super.message});

  TokenizationActivityState copyWith(
      {Status? status, List<TokenizationActivityItem>? data, String? message}) {
    return TokenizationActivityState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
