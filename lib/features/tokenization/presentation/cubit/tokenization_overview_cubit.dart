import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/tokenization_overview_data.dart';
import '../../domain/repositories/tokenization_repository.dart';
import 'tokenization_overview_state.dart';
import '../../../../core/utils/result.dart';

/// Cubit responsible for loading the tokenisation hub overview.
class TokenizationOverviewCubit extends Cubit<TokenizationOverviewState> {
  final TokenizationRepository _repository;
  TokenizationOverviewCubit(this._repository)
      : super(const TokenizationOverviewState());

  Future<void> loadOverview() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.fetchOverview();
    if (result is Success<TokenizationOverviewData>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<TokenizationOverviewData>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
