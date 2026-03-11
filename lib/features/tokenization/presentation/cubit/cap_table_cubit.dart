import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/ownership_holder.dart';
import '../../domain/repositories/tokenization_repository.dart';
import '../../../../core/utils/result.dart';
import 'cap_table_state.dart';

/// Cubit for loading the ownership/cap table of a programme.
class CapTableCubit extends Cubit<CapTableState> {
  final TokenizationRepository _repository;
  CapTableCubit(this._repository) : super(const CapTableState());

  Future<void> loadCapTable(String programId) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.fetchCapTable(programId);
    if (result is Success<List<OwnershipHolder>>) {
      final holders = result.value;
      emit(state.copyWith(
          status: holders.isEmpty ? Status.empty : Status.success,
          data: holders));
    } else if (result is Error<List<OwnershipHolder>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
