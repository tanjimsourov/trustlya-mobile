import '../../../../core/utils/result.dart';
import '../entities/tokenized_asset_program.dart';
import '../entities/issuance_stage.dart';
import '../entities/investor_profile.dart';
import '../entities/onboarding_case.dart';
import '../entities/ownership_holder.dart';
import '../entities/lifecycle_event.dart';
import '../entities/compliance_checkpoint.dart';
import '../entities/issuance_metric.dart';
import '../entities/servicing_alert.dart';
import '../entities/tokenization_overview_data.dart';
import '../entities/tokenization_activity_item.dart';

/// Defines operations available for the tokenisation module. Provides
/// access to overview statistics, programmes, workflows and analytics.
abstract class TokenizationRepository {
  Future<Result<TokenizationOverviewData>> fetchOverview();
  Future<Result<List<TokenizedAssetProgram>>> fetchPrograms();
  Future<Result<TokenizedAssetProgram>> fetchProgramDetail(String programId);
  Future<Result<List<IssuanceStage>>> fetchIssuanceWorkflow(String programId);
  Future<Result<List<OnboardingCase>>> fetchInvestorQueue();
  Future<Result<List<OwnershipHolder>>> fetchCapTable(String programId);
  Future<Result<List<LifecycleEvent>>> fetchLifecycleEvents(String programId);
  Future<Result<List<ComplianceCheckpoint>>> fetchComplianceReadiness(
      String programId);
  Future<Result<List<IssuanceMetric>>> fetchIssuanceAnalytics(String programId);
  Future<Result<List<TokenizationActivityItem>>> fetchActivity();
}
