import '../../../../core/utils/result.dart';
import '../entities/carbon_credit.dart';
import '../entities/carbon_transaction.dart';

/// Contract for carbon credit operations.
import '../entities/carbon_project.dart';
import '../entities/carbon_project_detail.dart';
import '../entities/carbon_holding.dart';
import '../entities/marketplace_dashboard_data.dart';
import '../entities/impact_analytics.dart';
import '../entities/achievement.dart';

/// Contract for carbon credit operations. Provides access to the
/// marketplace dashboard, project discovery, purchase/retirement flows
/// and analytics. Legacy methods for credits are retained for
/// backwards compatibility.
abstract class CarbonRepository {
  // Marketplace & discovery
  Future<Result<MarketplaceDashboardData>> getDashboardData();
  Future<Result<List<CarbonProject>>> getProjects({String? category});
  Future<Result<CarbonProjectDetail>> getProjectDetail(String id);

  // Portfolio & transactions
  Future<Result<List<CarbonHolding>>> getHoldings();
  Future<Result<List<CarbonTransaction>>> getTransactionHistory();

  // Actions
  Future<Result<CarbonTransaction>> buyCredits(
      String projectId, double quantity);
  Future<Result<CarbonTransaction>> retireCredits(
      String projectId, double quantity,
      {String? reason});

  // Analytics & achievements
  Future<Result<ImpactAnalytics>> getImpactAnalytics();
  Future<Result<List<Achievement>>> getAchievements();

  // ------------------------------------------------------------------
  // Legacy API (deprecated)
  Future<Result<List<CarbonCredit>>> getMarketplace();
  Future<Result<CarbonCredit>> getCreditDetail(String id);
  Future<Result<CarbonTransaction>> sellCredits(String id, double quantity);
}
