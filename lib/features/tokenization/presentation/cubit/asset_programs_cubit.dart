import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/tokenized_asset_program.dart';
import '../../domain/repositories/tokenization_repository.dart';
import '../../../../core/utils/result.dart';
import 'asset_programs_state.dart';

/// Loads the list of tokenised asset programmes.
class AssetProgramsCubit extends Cubit<AssetProgramsState> {
  final TokenizationRepository _repository;
  AssetProgramsCubit(this._repository) : super(const AssetProgramsState());

  Future<void> loadPrograms() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.fetchPrograms();
    if (result is Success<List<TokenizedAssetProgram>>) {
      final data = result.value;
      emit(state.copyWith(
          status: data.isEmpty ? Status.empty : Status.success, data: data));
    } else if (result is Error<List<TokenizedAssetProgram>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
