import '../../../../core/utils/result.dart';
import '../entities/payment_method.dart';

/// Contract defining operations to retrieve and modify payment methods.
abstract class PaymentMethodsRepository {
  /// Returns the list of all payment methods associated with the user.
  Future<Result<List<PaymentMethod>>> getPaymentMethods();

  /// Adds a new payment method. Returns the created method on success.
  Future<Result<PaymentMethod>> addPaymentMethod(PaymentMethod method);
}
