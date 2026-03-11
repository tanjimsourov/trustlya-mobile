import '../../../../core/utils/result.dart';
import '../entities/mission.dart';

/// Contract for retrieving and claiming missions/rewards.
abstract class RewardsRepository {
  Future<Result<List<Mission>>> getMissions();
  Future<Result<Mission>> claimReward(String id);
}
