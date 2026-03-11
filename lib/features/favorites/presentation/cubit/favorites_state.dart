import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/favorite_item.dart';

/// State for the favourites module. Contains the list of favourites
/// along with derived category information and the currently
/// selected filter. Extends [BaseState] to provide status and
/// message handling.
class FavoritesState extends BaseState<List<FavoriteItem>?> {
  final List<String> categories;
  final String selectedCategory;

  const FavoritesState({
    super.status,
    super.data,
    super.message,
    this.categories = const [],
    this.selectedCategory = 'All',
  });

  @override
  FavoritesState copyWith({
    Status? status,
    List<FavoriteItem>? data,
    String? message,
    List<String>? categories,
    String? selectedCategory,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
