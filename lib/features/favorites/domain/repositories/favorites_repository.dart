import '../../../../core/utils/result.dart';
import '../entities/favorite_item.dart';

/// Contract for managing user favourites. This repository returns
/// the current list of favourites and allows adding or removing
/// favourites. All operations return [Result]s for error handling.
abstract class FavoritesRepository {
  /// Returns the current list of favourite items.
  Future<Result<List<FavoriteItem>>> getFavorites();

  /// Adds the provided [item] to favourites. If the item already
  /// exists, this operation is a no‑op.
  Future<Result<void>> addFavorite(FavoriteItem item);

  /// Removes a favourite with the specified [id]. If no item with
  /// the id exists, this operation is a no‑op.
  Future<Result<void>> removeFavorite(String id);
}
