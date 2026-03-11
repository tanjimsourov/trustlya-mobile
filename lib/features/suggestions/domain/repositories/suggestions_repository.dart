import '../../../../core/utils/result.dart';
import '../entities/suggestion_item.dart';

/// Contract for retrieving smart suggestions. A repository
/// implementation could use heuristics or AI to generate
/// suggestions; this mock returns a static list.
abstract class SuggestionsRepository {
  Future<Result<List<SuggestionItem>>> getSuggestions();
}
