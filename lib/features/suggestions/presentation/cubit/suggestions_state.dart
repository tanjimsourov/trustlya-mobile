import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/suggestion_item.dart';

/// State for the smart suggestions page. Holds the list of
/// suggestions along with category filtering information.
class SuggestionsState extends BaseState<List<SuggestionItem>?> {
  final List<String> categories;
  final String selectedCategory;

  const SuggestionsState({
    super.status,
    super.data,
    super.message,
    this.categories = const [],
    this.selectedCategory = 'All',
  });

  @override
  SuggestionsState copyWith({
    Status? status,
    List<SuggestionItem>? data,
    String? message,
    List<String>? categories,
    String? selectedCategory,
  }) {
    return SuggestionsState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
