import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/cubit/base_state.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/settlement_instruction.dart';
import '../../domain/repositories/post_trade_repository.dart';
import 'settlement_detail_state.dart';

/// Cubit for loading a specific settlement instruction by its id.
/// Emits loading, success or error depending on repository outcome.
class SettlementDetailCubit extends Cubit<SettlementDetailState> {
  final PostTradeRepository _repository;
  SettlementDetailCubit(this._repository)
      : super(const SettlementDetailState());

  Future<void> loadDetail(String id) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.fetchSettlementDetail(id);
    if (result is Success<SettlementInstruction>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<SettlementInstruction>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
