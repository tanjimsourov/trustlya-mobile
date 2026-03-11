import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/compliance_checkpoint.dart';
import '../../domain/repositories/tokenization_repository.dart';
import '../../../../core/utils/result.dart';
import 'compliance_readiness_state.dart';

/// Cubit for loading compliance checkpoints for a programme.
class ComplianceReadinessCubit extends Cubit<ComplianceReadinessState> {
  final TokenizationRepository _repository;
  ComplianceReadinessCubit(this._repository)
      : super(const ComplianceReadinessState());

  /// Loads the compliance checkpoints for the given programme. Emits
  /// [Status.loading] while fetching and updates the state based on
  /// whether data was returned, absent or an error occurred.
  Future<void> loadCheckpoints(String programId) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.fetchComplianceReadiness(programId);
    if (result is Success<List<ComplianceCheckpoint>>) {
      final cps = result.value;
      emit(state.copyWith(
          status: cps.isEmpty ? Status.empty : Status.success, data: cps));
    } else if (result is Error<List<ComplianceCheckpoint>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
