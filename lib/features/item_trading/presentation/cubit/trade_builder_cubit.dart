import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/item.dart';
import 'trade_builder_state.dart';

/// Cubit for building a trade. It keeps two lists of items – those
/// offered by the user and those requested from another trader – and
/// calculates the total values to determine if the trade is allowed.
class TradeBuilderCubit extends Cubit<TradeBuilderState> {
  TradeBuilderCubit() : super(const TradeBuilderState());

  void addOffered(Item item) {
    final offered = List<Item>.from(state.offered)..add(item);
    _recalculate(offered: offered, requested: state.requested);
  }

  void removeOffered(Item item) {
    final offered = List<Item>.from(state.offered)..remove(item);
    _recalculate(offered: offered, requested: state.requested);
  }

  void addRequested(Item item) {
    final requested = List<Item>.from(state.requested)..add(item);
    _recalculate(offered: state.offered, requested: requested);
  }

  void removeRequested(Item item) {
    final requested = List<Item>.from(state.requested)..remove(item);
    _recalculate(offered: state.offered, requested: requested);
  }

  void clear() {
    _recalculate(offered: [], requested: []);
  }

  void _recalculate(
      {required List<Item> offered, required List<Item> requested}) {
    final offeredValue = offered.fold<double>(0, (sum, i) => sum + i.price);
    final requestedValue = requested.fold<double>(0, (sum, i) => sum + i.price);
    final allowed =
        requestedValue == 0 ? false : offeredValue >= requestedValue * 0.9;
    emit(state.copyWith(
      offered: offered,
      requested: requested,
      offeredValue: offeredValue,
      requestedValue: requestedValue,
      tradeAllowed: allowed,
    ));
  }
}
