import '../../../../core/utils/result.dart';
import '../entities/promotion_offer.dart';

/// Contract for retrieving available promotions and offers. A
/// repository implementation provides the current list of offers.
abstract class PromotionsRepository {
  /// Returns a list of available promotions.
  Future<Result<List<PromotionOffer>>> getPromotions();
}
