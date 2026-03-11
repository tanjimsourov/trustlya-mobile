import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/tokenization_activity_item.dart';
import '../../domain/repositories/tokenization_repository.dart';
import '../../../../core/utils/result.dart';
import 'tokenization_activity_state.dart';

/// Cubit for loading recent tokenisation activities across all programmes.
class TokenizationActivityCubit extends Cubit<TokenizationActivityState> {
  final TokenizationRepository _repository;
  TokenizationActivityCubit(this._repository)
      : super(const TokenizationActivityState());

  /// Fetches activity items from the repository. Updates state based on
  /// whether the feed returned data, was empty or failed.
  Future<void> loadActivity() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.fetchActivity();
    if (result is Success<List<TokenizationActivityItem>>) {
      final items = result.value;
      emit(state.copyWith(
          status: items.isEmpty ? Status.empty : Status.success, data: items));
    } else if (result is Error<List<TokenizationActivityItem>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
