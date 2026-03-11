import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/tokenization_overview_data.dart';

/// State for the tokenisation overview page. Holds summary metrics
/// displayed on the hub page.
class TokenizationOverviewState extends BaseState<TokenizationOverviewData?> {
  const TokenizationOverviewState(
      {super.status = Status.initial, super.data, super.message});

  TokenizationOverviewState copyWith(
      {Status? status, TokenizationOverviewData? data, String? message}) {
    return TokenizationOverviewState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
