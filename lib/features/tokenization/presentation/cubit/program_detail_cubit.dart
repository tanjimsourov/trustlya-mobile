import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/tokenized_asset_program.dart';
import '../../domain/repositories/tokenization_repository.dart';
import '../../../../core/utils/result.dart';
import 'program_detail_state.dart';

/// Loads detailed information about a single tokenised asset programme.
class ProgramDetailCubit extends Cubit<ProgramDetailState> {
  final TokenizationRepository _repository;
  ProgramDetailCubit(this._repository) : super(const ProgramDetailState());

  Future<void> loadProgram(String id) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.fetchProgramDetail(id);
    if (result is Success<TokenizedAssetProgram>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<TokenizedAssetProgram>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
