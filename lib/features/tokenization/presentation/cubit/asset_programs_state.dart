import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/tokenized_asset_program.dart';

/// State for the asset programs listing page. Holds a list of
/// programmes available for tokenisation.
class AssetProgramsState extends BaseState<List<TokenizedAssetProgram>?> {
  const AssetProgramsState(
      {super.status = Status.initial, super.data, super.message});

  AssetProgramsState copyWith(
      {Status? status, List<TokenizedAssetProgram>? data, String? message}) {
    return AssetProgramsState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
