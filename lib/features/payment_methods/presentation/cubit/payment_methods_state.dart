import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/payment_method.dart';

/// State for the payment methods feature. Extends [BaseState] with
/// `List<PaymentMethod>` as the payload. This allows signalling
/// loading, error and success states when fetching or adding methods.
class PaymentMethodsState extends BaseState<List<PaymentMethod>> {
  const PaymentMethodsState(
      {super.status = Status.initial, super.data, super.message});

  PaymentMethodsState copyWith(
      {Status? status, List<PaymentMethod>? data, String? message}) {
    return PaymentMethodsState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
