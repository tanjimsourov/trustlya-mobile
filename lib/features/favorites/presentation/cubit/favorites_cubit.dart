import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../domain/entities/favorite_item.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../../../shared/cubit/base_state.dart';
import 'favorites_state.dart';

/// Cubit for managing favourites. It loads the list of favourites
/// from the repository, exposes category filters and allows
/// removing entries. Adding favourites is handled by the calling
/// module via the repository directly to avoid coupling the cubit
/// to all modules.
class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _repo;
  FavoritesCubit(this._repo)
      : super(const FavoritesState(status: Status.initial));

  /// Loads favourites from the repository. Computes the list of
  /// categories (adding an 'All' catch‑all) and sets the initial
  /// selected category to 'All'.
  Future<void> load() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repo.getFavorites();
    result.when(
      success: (list) {
        final cats = <String>{};
        for (final item in list) {
          cats.add(item.type);
        }
        final categories = ['All', ...cats.toList()];
        emit(state.copyWith(
            status: list.isEmpty ? Status.empty : Status.success,
            data: list,
            categories: categories,
            selectedCategory: 'All'));
      },
      failure: (e) {
        emit(state.copyWith(
            status: Status.error,
            message: e.message ?? 'Failed to load favourites'));
      },
    );
  }

  /// Updates the currently selected category. This does not mutate
  /// the underlying data; the view should filter based on this
  /// property when rendering.
  void selectCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }

  /// Removes a favourite and reloads the list.
  Future<void> remove(String id) async {
    await _repo.removeFavorite(id);
    await load();
  }
}
