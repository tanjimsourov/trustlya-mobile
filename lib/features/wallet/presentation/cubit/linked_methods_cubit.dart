import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/linked_method.dart';
import '../../domain/repositories/wallet_repository.dart';
import 'linked_methods_state.dart';

/// Cubit responsible for loading and managing linked payout methods. This
/// class exposes functions to fetch the list of methods and to add or
/// remove a payout method. It relies on [WalletRepository] for
/// persistence.
class LinkedMethodsCubit extends Cubit<LinkedMethodsState> {
  final WalletRepository _repository;
  LinkedMethodsCubit(this._repository) : super(const LinkedMethodsState());

  /// Loads the current list of linked payout methods. Emits loading and
  /// success/empty or error states.
  Future<void> load() async {
    emit(state.copyWith(status: Status.loading));
    final res = await _repository.getLinkedMethods();
    if (res is Success<List<LinkedMethod>>) {
      final methods = res.value;
      emit(state.copyWith(
          status: methods.isEmpty ? Status.empty : Status.success,
          data: methods));
    } else if (res is Error<List<LinkedMethod>>) {
      emit(state.copyWith(status: Status.error, message: res.message));
    }
  }

  /// Adds a new linked payout method and refreshes the list on success.
  Future<void> addMethod(LinkedMethod method) async {
    emit(state.copyWith(status: Status.loading));
    final res = await _repository.addLinkedMethod(method);
    if (res is Success<void>) {
      // Reload after adding
      await load();
    } else if (res is Error<void>) {
      emit(state.copyWith(status: Status.error, message: res.message));
    }
  }

  /// Removes an existing linked method by id and refreshes the list on success.
  Future<void> removeMethod(String id) async {
    emit(state.copyWith(status: Status.loading));
    final res = await _repository.removeLinkedMethod(id);
    if (res is Success<void>) {
      await load();
    } else if (res is Error<void>) {
      emit(state.copyWith(status: Status.error, message: res.message));
    }
  }
}
