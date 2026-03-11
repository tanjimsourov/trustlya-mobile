import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/issuance_stage.dart';
import '../../domain/repositories/tokenization_repository.dart';
import '../../../../core/utils/result.dart';
import 'issuance_workflow_state.dart';

/// Loads the issuance workflow (list of stages) for a programme.
class IssuanceWorkflowCubit extends Cubit<IssuanceWorkflowState> {
  final TokenizationRepository _repository;
  IssuanceWorkflowCubit(this._repository)
      : super(const IssuanceWorkflowState());

  Future<void> loadWorkflow(String programId) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.fetchIssuanceWorkflow(programId);
    if (result is Success<List<IssuanceStage>>) {
      final stages = result.value;
      emit(state.copyWith(
          status: stages.isEmpty ? Status.empty : Status.success,
          data: stages));
    } else if (result is Error<List<IssuanceStage>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
