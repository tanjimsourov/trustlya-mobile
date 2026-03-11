import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/search_result_data.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/entities/search_result.dart';
import 'search_state.dart';

/// Manages the search flow across modules. Loads suggested and recent
/// searches on initialization and performs search queries. Maintains
/// the selected category filter.
class SearchCubit extends Cubit<SearchState> {
  final SearchRepository _repository;

  SearchCubit(this._repository)
      : super(const SearchState(status: Status.loading)) {
    _init();
  }

  Future<void> _init() async {
    emit(state.copyWith(status: Status.loading));
    final recentsRes = await _repository.getRecentSearches();
    final suggestionsRes = await _repository.getSuggestedSearches();
    final data = SearchResultData(
      results: const [],
      recentSearches: recentsRes.getOrElse(() => []),
      suggestions: suggestionsRes.getOrElse(() => []),
    );
    emit(state.copyWith(status: Status.success, data: data));
  }

  /// Updates the selected category and optionally performs a search
  /// if a [query] is provided.
  Future<void> selectCategory(String category, {String query = ''}) async {
    final currentData = state.data ?? const SearchResultData();
    emit(state.copyWith(status: Status.loading));
    if (query.isNotEmpty) {
      final res = await _repository.search(query, category: category);
      final results = res.getOrElse(() => []);
      final newData =
          currentData.copyWith(results: results, selectedCategory: category);
      emit(state.copyWith(
          status: results.isEmpty ? Status.empty : Status.success,
          data: newData));
    } else {
      final newData = currentData.copyWith(selectedCategory: category);
      emit(state.copyWith(status: Status.success, data: newData));
    }
  }

  /// Executes a search query using the selected category. Saves the
  /// term to recent searches.
  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;
    final currentData = state.data ?? const SearchResultData();
    emit(state.copyWith(status: Status.loading));
    final res =
        await _repository.search(query, category: currentData.selectedCategory);
    final results = res.getOrElse(() => []);
    final recents = currentData.recentSearches;
    await _repository.saveSearch(query);
    final recentsRes = await _repository.getRecentSearches();
    final newData = currentData.copyWith(
      results: results,
      recentSearches: recentsRes.getOrElse(() => recents),
    );
    emit(state.copyWith(
        status: results.isEmpty ? Status.empty : Status.success,
        data: newData));
  }

  /// Clears current results and reloads suggestions/recents.
  Future<void> clear() async {
    emit(state.copyWith(status: Status.loading));
    final recentsRes = await _repository.getRecentSearches();
    final suggestionsRes = await _repository.getSuggestedSearches();
    final currentData = state.data ?? const SearchResultData();
    final newData = currentData.copyWith(
      results: [],
      recentSearches: recentsRes.getOrElse(() => []),
      suggestions: suggestionsRes.getOrElse(() => []),
    );
    emit(state.copyWith(status: Status.success, data: newData));
  }
}
