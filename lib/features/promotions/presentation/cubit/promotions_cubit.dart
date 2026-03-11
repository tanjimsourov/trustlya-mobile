import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../domain/entities/promotion_offer.dart';
import '../../domain/repositories/promotions_repository.dart';
import '../../../../shared/cubit/base_state.dart';
import 'promotions_state.dart';

/// Cubit to manage promotions. Loads the list of offers from the
/// repository and exposes category filtering. Does not support
/// claiming directly; handle claims via the route action or a
/// dedicated rewards cubit if needed.
class PromotionsCubit extends Cubit<PromotionsState> {
  final PromotionsRepository _repo;
  PromotionsCubit(this._repo)
      : super(const PromotionsState(status: Status.initial));

  /// Loads promotions from the repository, computing unique
  /// categories and setting the default selected category to 'All'.
  Future<void> load() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repo.getPromotions();
    result.when(
      success: (list) {
        final cats = <String>{};
        for (final offer in list) {
          cats.add(offer.category);
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
            message: e.message ?? 'Failed to load promotions'));
      },
    );
  }

  /// Sets the selected category filter.
  void selectCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }
}
