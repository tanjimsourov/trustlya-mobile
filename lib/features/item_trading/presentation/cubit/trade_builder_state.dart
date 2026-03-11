import '../../domain/entities/item.dart';

/// State for the trade builder page. Keeps track of the items offered
/// by the user and the items requested from the counterparty. It
/// computes the total values of each side and whether the trade is
/// allowed. A trade is allowed if the offered value is at least
/// 90% of the requested value (to account for fees and negotiation).
class TradeBuilderState {
  final List<Item> offered;
  final List<Item> requested;
  final double offeredValue;
  final double requestedValue;
  final bool tradeAllowed;

  const TradeBuilderState({
    this.offered = const [],
    this.requested = const [],
    this.offeredValue = 0,
    this.requestedValue = 0,
    this.tradeAllowed = false,
  });

  TradeBuilderState copyWith({
    List<Item>? offered,
    List<Item>? requested,
    double? offeredValue,
    double? requestedValue,
    bool? tradeAllowed,
  }) {
    return TradeBuilderState(
      offered: offered ?? this.offered,
      requested: requested ?? this.requested,
      offeredValue: offeredValue ?? this.offeredValue,
      requestedValue: requestedValue ?? this.requestedValue,
      tradeAllowed: tradeAllowed ?? this.tradeAllowed,
    );
  }
}
