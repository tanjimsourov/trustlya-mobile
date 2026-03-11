import '../../../../core/utils/result.dart';
import '../entities/activity_item.dart';

/// Contract for retrieving aggregated activities across all modules.
abstract class ActivityRepository {
  /// Loads a list of all activity items. The returned list should
  /// ideally be sorted by date descending.
  Future<Result<List<ActivityItem>>> getActivities();
}
