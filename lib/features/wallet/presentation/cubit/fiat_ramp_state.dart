import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/fiat_method.dart';

/// State for the fiat on/off ramp page. Holds the list of available
/// [FiatMethod]s.
class FiatRampState extends BaseState<List<FiatMethod>?> {
  const FiatRampState(
      {Status status = Status.initial, List<FiatMethod>? data, String? message})
      : super(status: status, data: data, message: message);

  FiatRampState copyWith(
      {Status? status, List<FiatMethod>? data, String? message}) {
    return FiatRampState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
