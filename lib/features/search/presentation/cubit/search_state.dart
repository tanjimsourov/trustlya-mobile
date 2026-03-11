import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/search_result_data.dart';

/// State for the search page. Extends [BaseState] with a
/// [SearchResultData] payload containing results, suggestions, recents,
/// categories and the selected category. Use [status] to handle
/// loading, success, empty and error states.
class SearchState extends BaseState<SearchResultData> {
  const SearchState({required super.status, super.data, super.message});

  SearchState copyWith({
    Status? status,
    SearchResultData? data,
    String? message,
  }) {
    return SearchState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
