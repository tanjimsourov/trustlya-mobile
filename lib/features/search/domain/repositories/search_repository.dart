import '../../../../core/utils/result.dart';
import '../entities/search_result.dart';

/// Defines the contract for performing cross‑module search operations.
/// Implementations must provide results aggregated from multiple
/// features (wallet, trading, casino, carbon, etc.). It also exposes
/// recent and suggested search terms.
abstract class SearchRepository {
  /// Performs a search for [query]. If [category] is provided and
  /// not "All", the results should be filtered to that category.
  Future<Result<List<SearchResult>>> search(String query, {String? category});

  /// Returns a list of recent search strings entered by the user.
  Future<Result<List<String>>> getRecentSearches();

  /// Returns a list of suggested search terms. These suggestions can
  /// be static or derived from trending topics across modules.
  Future<Result<List<String>>> getSuggestedSearches();

  /// Saves a search term to the recent searches list. Implementations
  /// should de‑duplicate and cap the number of stored recents.
  Future<void> saveSearch(String term);
}
