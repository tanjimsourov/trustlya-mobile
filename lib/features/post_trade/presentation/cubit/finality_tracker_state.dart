import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/finality_event.dart';

/// State for the finality tracker page. Holds a list of events
/// across all settlement instructions.
class FinalityTrackerState extends BaseState<List<FinalityEvent>?> {
  const FinalityTrackerState(
      {super.status = Status.initial, super.data, super.message});

  FinalityTrackerState copyWith(
      {Status? status, List<FinalityEvent>? data, String? message}) {
    return FinalityTrackerState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
