import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/promotion_offer.dart';

/// State for the promotions page. Contains the list of offers,
/// categories for filtering and the selected category. Extends
/// [BaseState] for status and message.
class PromotionsState extends BaseState<List<PromotionOffer>?> {
  final List<String> categories;
  final String selectedCategory;

  const PromotionsState({
    super.status,
    super.data,
    super.message,
    this.categories = const [],
    this.selectedCategory = 'All',
  });

  @override
  PromotionsState copyWith({
    Status? status,
    List<PromotionOffer>? data,
    String? message,
    List<String>? categories,
    String? selectedCategory,
  }) {
    return PromotionsState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
