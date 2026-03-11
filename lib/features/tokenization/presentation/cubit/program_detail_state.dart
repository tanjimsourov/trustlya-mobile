import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/tokenized_asset_program.dart';

/// State for the program detail page. Holds details about a single
/// tokenised asset programme.
class ProgramDetailState extends BaseState<TokenizedAssetProgram?> {
  const ProgramDetailState(
      {super.status = Status.initial, super.data, super.message});

  ProgramDetailState copyWith(
      {Status? status, TokenizedAssetProgram? data, String? message}) {
    return ProgramDetailState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
