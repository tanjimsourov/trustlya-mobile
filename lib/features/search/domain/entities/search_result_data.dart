import 'search_result.dart';

/// Encapsulates the aggregated data returned by the search cubit. It
/// includes the actual [results] along with [suggestions] and
/// [recentSearches]. The [categories] list defines available
/// category filters (including 'All'), and [selectedCategory]
/// indicates which category is currently active.
class SearchResultData {
  final List<SearchResult> results;
  final List<String> suggestions;
  final List<String> recentSearches;
  final List<String> categories;
  final String selectedCategory;

  const SearchResultData({
    this.results = const [],
    this.suggestions = const [],
    this.recentSearches = const [],
    this.categories = const [
      'All',
      'Assets',
      'Items',
      'Games',
      'Carbon',
      'Transactions',
      'Tokenisation',
      'Settlement'
    ],
    this.selectedCategory = 'All',
  });

  SearchResultData copyWith({
    List<SearchResult>? results,
    List<String>? suggestions,
    List<String>? recentSearches,
    List<String>? categories,
    String? selectedCategory,
  }) {
    return SearchResultData(
      results: results ?? this.results,
      suggestions: suggestions ?? this.suggestions,
      recentSearches: recentSearches ?? this.recentSearches,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
