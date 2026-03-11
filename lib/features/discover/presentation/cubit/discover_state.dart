import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/discover_item.dart';

/// State for the discover page. Includes the list of curated
/// discovery items, category information and the selected
/// category.
class DiscoverState extends BaseState<List<DiscoverItem>?> {
  final List<String> categories;
  final String selectedCategory;

  const DiscoverState({
    super.status,
    super.data,
    super.message,
    this.categories = const [],
    this.selectedCategory = 'All',
  });

  @override
  DiscoverState copyWith({
    Status? status,
    List<DiscoverItem>? data,
    String? message,
    List<String>? categories,
    String? selectedCategory,
  }) {
    return DiscoverState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
