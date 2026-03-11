import '../../../../core/utils/result.dart';
import '../entities/discover_item.dart';

/// Contract for retrieving discovery items used in the discover
/// page. The repository returns a list of curated items across
/// modules.
abstract class DiscoverRepository {
  Future<Result<List<DiscoverItem>>> getDiscoverItems();
}
