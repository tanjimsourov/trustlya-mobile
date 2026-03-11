import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../domain/entities/discover_item.dart';
import '../../domain/repositories/discover_repository.dart';
import '../../../../shared/cubit/base_state.dart';
import 'discover_state.dart';

/// Cubit responsible for loading curated discovery items and
/// exposing category filtering. When the selected category changes
/// the view should filter the list accordingly.
class DiscoverCubit extends Cubit<DiscoverState> {
  final DiscoverRepository _repo;
  DiscoverCubit(this._repo)
      : super(const DiscoverState(status: Status.initial));

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading));
    final res = await _repo.getDiscoverItems();
    res.when(
      success: (items) {
        final cats = <String>{};
        for (final item in items) {
          cats.add(item.type);
        }
        final categories = ['All', ...cats.toList()];
        emit(state.copyWith(
          status: items.isEmpty ? Status.empty : Status.success,
          data: items,
          categories: categories,
          selectedCategory: 'All',
        ));
      },
      failure: (e) {
        emit(state.copyWith(
            status: Status.error,
            message: e.message ?? 'Failed to load discover'));
      },
    );
  }

  void selectCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }
}
