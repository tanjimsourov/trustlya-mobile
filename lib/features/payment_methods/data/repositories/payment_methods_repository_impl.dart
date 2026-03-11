import 'dart:async';

import '../../../../core/utils/result.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/payment_methods_repository.dart';

abstract class PaymentMethodsDataSource implements PaymentMethodsRepository {}

class MockPaymentMethodsDataSource implements PaymentMethodsDataSource {
  final List<PaymentMethod> _methods = [
    PaymentMethod(
      id: '1',
      type: 'card',
      provider: 'Visa',
      maskedNumber: '**** **** **** 1234',
      expiryDate: '12/27',
      isDefault: true,
    ),
    PaymentMethod(
      id: '2',
      type: 'card',
      provider: 'MasterCard',
      maskedNumber: '**** **** **** 5678',
      expiryDate: '11/26',
      isDefault: false,
    ),
    PaymentMethod(
      id: '3',
      type: 'bank',
      provider: 'Metropolis Bank',
      maskedNumber: '****1234',
      expiryDate: '',
      isDefault: false,
    ),
    PaymentMethod(
      id: '4',
      type: 'e-wallet',
      provider: 'Trustlya Wallet',
      maskedNumber: '',
      expiryDate: '',
      isDefault: false,
    ),
    PaymentMethod(
      id: '5',
      type: 'crypto',
      provider: 'Crypto Bridge',
      maskedNumber: '0xABC123...',
      expiryDate: '',
      isDefault: false,
    ),
  ];

  @override
  Future<Result<List<PaymentMethod>>> getPaymentMethods() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Result.success(List.unmodifiable(_methods));
  }

  @override
  Future<Result<PaymentMethod>> addPaymentMethod(PaymentMethod method) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _methods.add(method);
    return Result.success(method);
  }
}

class PaymentMethodsRepositoryImpl implements PaymentMethodsRepository {
  PaymentMethodsRepositoryImpl({PaymentMethodsDataSource? dataSource})
      : _dataSource = dataSource ?? MockPaymentMethodsDataSource();

  final PaymentMethodsDataSource _dataSource;

  @override
  Future<Result<List<PaymentMethod>>> getPaymentMethods() {
    return _dataSource.getPaymentMethods();
  }

  @override
  Future<Result<PaymentMethod>> addPaymentMethod(PaymentMethod method) {
    return _dataSource.addPaymentMethod(method);
  }
}
