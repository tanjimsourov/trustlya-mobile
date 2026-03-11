import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/counterparty_exposure.dart';

/// State for the counterparty exposure page. Holds a list of
/// exposure records by counterparty and risk level.
class CounterpartyExposureState extends BaseState<List<CounterpartyExposure>?> {
  const CounterpartyExposureState(
      {super.status = Status.initial, super.data, super.message});

  CounterpartyExposureState copyWith(
      {Status? status, List<CounterpartyExposure>? data, String? message}) {
    return CounterpartyExposureState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
