import '../../../../core/utils/result.dart';
import '../entities/post_trade_dashboard_data.dart';
import '../entities/settlement_instruction.dart';
import '../entities/reconciliation_break.dart';
import '../entities/settlement_exception.dart';
import '../entities/treasury_position.dart';
import '../entities/counterparty_exposure.dart';
import '../entities/finality_event.dart';
import '../entities/audit_record.dart';
import '../entities/sla_metric.dart';

/// Contract for the post‑trade module data source. Defines all
/// operations required to power the post‑trade and settlement
/// workflows including queue management, reconciliation and
/// reporting. Each method returns a [Result] which encapsulates
/// success or failure.
abstract class PostTradeRepository {
  Future<Result<PostTradeDashboardData>> fetchDashboard();
  Future<Result<List<SettlementInstruction>>> fetchSettlementQueue();
  Future<Result<SettlementInstruction>> fetchSettlementDetail(String id);
  Future<Result<List<ReconciliationBreak>>> fetchReconciliationCenter();
  Future<Result<List<SettlementException>>> fetchExceptions();
  Future<Result<List<TreasuryPosition>>> fetchTreasuryPositions();
  Future<Result<List<CounterpartyExposure>>> fetchCounterpartyExposure();
  Future<Result<List<FinalityEvent>>> fetchFinalityTracker();
  Future<Result<List<AuditRecord>>> fetchReportingAudit();
  Future<Result<List<SlaMetric>>> fetchSlaMetrics();
}
