import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/payment_methods_repository.dart';
import 'payment_methods_state.dart';

/// Cubit for retrieving and managing payment methods. Uses
/// [PaymentMethodsRepository] to fetch and add methods and emits
/// appropriate states to reflect progress.
class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  final PaymentMethodsRepository _repository;
  PaymentMethodsCubit(this._repository) : super(const PaymentMethodsState());

  Future<void> loadMethods() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getPaymentMethods();
    if (result is Success<List<PaymentMethod>>) {
      final list = result.value;
      emit(state.copyWith(
          status: list.isEmpty ? Status.empty : Status.success, data: list));
    } else if (result is Error<List<PaymentMethod>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> addMethod(PaymentMethod method) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.addPaymentMethod(method);
    if (result is Success<PaymentMethod>) {
      // Reload list after adding
      await loadMethods();
    } else if (result is Error<PaymentMethod>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
