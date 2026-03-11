import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../domain/entities/suggestion_item.dart';
import '../../domain/repositories/suggestions_repository.dart';
import '../../../../shared/cubit/base_state.dart';
import 'suggestions_state.dart';

/// Cubit that manages loading and filtering of smart suggestions.
/// Suggestions are curated hints or guidance for the user to take
/// relevant actions across the platform.
class SuggestionsCubit extends Cubit<SuggestionsState> {
  final SuggestionsRepository _repo;
  SuggestionsCubit(this._repo)
      : super(const SuggestionsState(status: Status.initial));

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading));
    final res = await _repo.getSuggestions();
    res.when(
      success: (list) {
        final cats = <String>{};
        for (final s in list) {
          cats.add(s.type);
        }
        final categories = ['All', ...cats.toList()];
        emit(state.copyWith(
          status: list.isEmpty ? Status.empty : Status.success,
          data: list,
          categories: categories,
          selectedCategory: 'All',
        ));
      },
      failure: (e) {
        emit(state.copyWith(
            status: Status.error,
            message: e.message ?? 'Failed to load suggestions'));
      },
    );
  }

  void selectCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }
}
