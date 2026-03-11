import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/fiat_method.dart';
import '../../domain/repositories/wallet_repository.dart';
import 'fiat_ramp_state.dart';

/// Cubit that loads the available fiat on/off ramp methods.
class FiatRampCubit extends Cubit<FiatRampState> {
  final WalletRepository _repository;
  FiatRampCubit(this._repository) : super(const FiatRampState());

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading));
    final res = await _repository.getFiatMethods();
    if (res is Success<List<FiatMethod>>) {
      emit(state.copyWith(status: Status.success, data: res.value));
    } else if (res is Error<List<FiatMethod>>) {
      emit(state.copyWith(status: Status.error, message: res.message));
    }
  }
}
