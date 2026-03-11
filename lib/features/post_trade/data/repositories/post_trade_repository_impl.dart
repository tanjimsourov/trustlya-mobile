import 'dart:async';

import '../../../../core/utils/result.dart';
import '../../domain/entities/audit_record.dart';
import '../../domain/entities/counterparty_exposure.dart';
import '../../domain/entities/finality_event.dart';
import '../../domain/entities/post_trade_dashboard_data.dart';
import '../../domain/entities/reconciliation_break.dart';
import '../../domain/entities/settlement_exception.dart';
import '../../domain/entities/settlement_instruction.dart';
import '../../domain/entities/settlement_leg.dart';
import '../../domain/entities/sla_metric.dart';
import '../../domain/entities/treasury_position.dart';
import '../../domain/repositories/post_trade_repository.dart';

abstract class PostTradeDataSource implements PostTradeRepository {}

class MockPostTradeDataSource implements PostTradeDataSource {
  final List<SettlementInstruction> _instructions = [
    SettlementInstruction(
      id: 'SI-20260101-001',
      reference: 'Paris Bond Settlement',
      date: DateTime(2026, 1, 15),
      status: SettlementStatus.queued,
      amount: 1000000,
      currency: 'EUR',
      counterparty: 'Euronext Paris',
      legs: [
        SettlementLeg(
          id: 'L1',
          fromAccount: 'Custody A',
          toAccount: 'Custody B',
          amount: 500000,
          currency: 'EUR',
          status: LegStatus.matched,
        ),
        SettlementLeg(
          id: 'L2',
          fromAccount: 'Custody A',
          toAccount: 'Custody C',
          amount: 500000,
          currency: 'EUR',
          status: LegStatus.unmatched,
        ),
      ],
    ),
    SettlementInstruction(
      id: 'SI-20260105-002',
      reference: 'Frankfurt Repo Settlement',
      date: DateTime(2026, 1, 20),
      status: SettlementStatus.processing,
      amount: 2500000,
      currency: 'EUR',
      counterparty: 'Deutsche Börse',
      legs: [
        SettlementLeg(
          id: 'L3',
          fromAccount: 'Treasury EUR',
          toAccount: 'Repo Counterparty',
          amount: 2500000,
          currency: 'EUR',
          status: LegStatus.matched,
        ),
      ],
    ),
    SettlementInstruction(
      id: 'SI-20260110-003',
      reference: 'Amsterdam Equity Settlement',
      date: DateTime(2026, 1, 25),
      status: SettlementStatus.settled,
      amount: 300000,
      currency: 'EUR',
      counterparty: 'Euroclear Netherlands',
      legs: [
        SettlementLeg(
          id: 'L4',
          fromAccount: 'Trading Account',
          toAccount: 'Clearing House',
          amount: 300000,
          currency: 'EUR',
          status: LegStatus.settled,
        ),
      ],
    ),
  ];

  final List<ReconciliationBreak> _breaks = [
    ReconciliationBreak(
      id: 'BRK-001',
      type: 'Cash Break',
      description: 'Mismatch in EUR cash balance after Paris bond settlement',
      amount: 10000,
      currency: 'EUR',
      date: DateTime(2026, 1, 16),
      status: BreakStatus.unresolved,
    ),
    ReconciliationBreak(
      id: 'BRK-002',
      type: 'Position Break',
      description: 'Equity quantity mismatch in Amsterdam settlement',
      amount: 5000,
      currency: 'EUR',
      date: DateTime(2026, 1, 26),
      status: BreakStatus.resolved,
    ),
  ];

  final List<SettlementException> _exceptions = [
    SettlementException(
      id: 'EX-001',
      instructionId: 'SI-20260101-001',
      severity: ExceptionSeverity.high,
      description: 'Unmatched leg remains pending past cut-off time',
      date: DateTime(2026, 1, 16),
      resolved: false,
    ),
    SettlementException(
      id: 'EX-002',
      instructionId: 'SI-20260105-002',
      severity: ExceptionSeverity.medium,
      description: 'Counterparty bank holidays delaying processing',
      date: DateTime(2026, 1, 21),
      resolved: true,
    ),
    SettlementException(
      id: 'EX-003',
      instructionId: 'SI-20260110-003',
      severity: ExceptionSeverity.low,
      description: 'Minor fee discrepancy resolved automatically',
      date: DateTime(2026, 1, 26),
      resolved: true,
    ),
  ];

  final List<TreasuryPosition> _positions = [
    TreasuryPosition(
      accountName: 'Trustlya Treasury EUR',
      currency: 'EUR',
      balance: 5000000,
      available: 4800000,
      pending: 200000,
    ),
    TreasuryPosition(
      accountName: 'Trustlya Treasury USD',
      currency: 'USD',
      balance: 2000000,
      available: 1900000,
      pending: 100000,
    ),
    TreasuryPosition(
      accountName: 'Trustlya Treasury GBP',
      currency: 'GBP',
      balance: 1500000,
      available: 1450000,
      pending: 50000,
    ),
  ];

  final List<CounterpartyExposure> _exposures = [
    CounterpartyExposure(
      counterparty: 'BNP Paribas',
      exposure: 1200000,
      currency: 'EUR',
      settlementDate: DateTime(2026, 2, 5),
      riskLevel: RiskLevel.low,
    ),
    CounterpartyExposure(
      counterparty: 'Santander',
      exposure: 900000,
      currency: 'EUR',
      settlementDate: DateTime(2026, 2, 8),
      riskLevel: RiskLevel.medium,
    ),
    CounterpartyExposure(
      counterparty: 'ING',
      exposure: 1500000,
      currency: 'EUR',
      settlementDate: DateTime(2026, 2, 10),
      riskLevel: RiskLevel.high,
    ),
  ];

  final List<FinalityEvent> _events = [
    FinalityEvent(
      id: 'FE-001',
      instructionId: 'SI-20260101-001',
      event: FinalityEventType.initiated,
      timestamp: DateTime(2026, 1, 15, 9, 0),
    ),
    FinalityEvent(
      id: 'FE-002',
      instructionId: 'SI-20260101-001',
      event: FinalityEventType.matched,
      timestamp: DateTime(2026, 1, 15, 10, 30),
    ),
    FinalityEvent(
      id: 'FE-003',
      instructionId: 'SI-20260101-001',
      event: FinalityEventType.failed,
      timestamp: DateTime(2026, 1, 15, 16, 0),
    ),
    FinalityEvent(
      id: 'FE-004',
      instructionId: 'SI-20260105-002',
      event: FinalityEventType.initiated,
      timestamp: DateTime(2026, 1, 20, 9, 0),
    ),
    FinalityEvent(
      id: 'FE-005',
      instructionId: 'SI-20260105-002',
      event: FinalityEventType.matched,
      timestamp: DateTime(2026, 1, 20, 10, 0),
    ),
    FinalityEvent(
      id: 'FE-006',
      instructionId: 'SI-20260105-002',
      event: FinalityEventType.initiated,
      timestamp: DateTime(2026, 1, 20, 15, 0),
    ),
    FinalityEvent(
      id: 'FE-007',
      instructionId: 'SI-20260110-003',
      event: FinalityEventType.initiated,
      timestamp: DateTime(2026, 1, 25, 9, 0),
    ),
    FinalityEvent(
      id: 'FE-008',
      instructionId: 'SI-20260110-003',
      event: FinalityEventType.matched,
      timestamp: DateTime(2026, 1, 25, 9, 30),
    ),
    FinalityEvent(
      id: 'FE-009',
      instructionId: 'SI-20260110-003',
      event: FinalityEventType.settled,
      timestamp: DateTime(2026, 1, 25, 10, 0),
    ),
  ];

  final List<AuditRecord> _audits = [
    AuditRecord(
      id: 'AUD-001',
      entity: 'SettlementInstruction',
      action: 'Created',
      timestamp: DateTime(2026, 1, 14, 18, 0),
      user: 'ops_user_1',
      description: 'Instruction SI-20260101-001 created for Paris bond trade',
    ),
    AuditRecord(
      id: 'AUD-002',
      entity: 'ReconciliationBreak',
      action: 'Identified',
      timestamp: DateTime(2026, 1, 16, 11, 15),
      user: 'system',
      description: 'Cash break BRK-001 flagged during matching',
    ),
    AuditRecord(
      id: 'AUD-003',
      entity: 'SettlementException',
      action: 'Raised',
      timestamp: DateTime(2026, 1, 16, 16, 10),
      user: 'ops_user_2',
      description:
          'Exception EX-001 raised for unmatched leg on SI-20260101-001',
    ),
    AuditRecord(
      id: 'AUD-004',
      entity: 'SettlementInstruction',
      action: 'Settled',
      timestamp: DateTime(2026, 1, 25, 11, 0),
      user: 'system',
      description: 'Instruction SI-20260110-003 successfully settled',
    ),
  ];

  final List<SlaMetric> _metrics = [
    SlaMetric(
      name: 'Settlement Completion Time',
      value: 98.0,
      target: 95.0,
      met: true,
      unit: '%',
    ),
    SlaMetric(
      name: 'Instruction Match Rate',
      value: 97.5,
      target: 98.0,
      met: false,
      unit: '%',
    ),
    SlaMetric(
      name: 'Break Resolution SLA',
      value: 90.0,
      target: 90.0,
      met: true,
      unit: '%',
    ),
  ];

  @override
  Future<Result<PostTradeDashboardData>> fetchDashboard() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final pending = _instructions
        .where((instruction) =>
            instruction.status == SettlementStatus.queued ||
            instruction.status == SettlementStatus.processing)
        .length;
    final breaks =
        _breaks.where((item) => item.status == BreakStatus.unresolved).length;
    final exceptions = _exceptions.where((item) => !item.resolved).length;
    final treasury = _positions.fold<double>(
      0,
      (sum, position) => sum + position.balance,
    );
    return Result.success(PostTradeDashboardData(
      totalInstructions: _instructions.length,
      pendingInstructions: pending,
      unresolvedBreaks: breaks,
      openExceptions: exceptions,
      exposures: _exposures.length,
      treasuryBalance: treasury,
    ));
  }

  @override
  Future<Result<List<SettlementInstruction>>> fetchSettlementQueue() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Result.success(List<SettlementInstruction>.from(_instructions));
  }

  @override
  Future<Result<SettlementInstruction>> fetchSettlementDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return Result.success(_instructions.firstWhere((item) => item.id == id));
    } catch (_) {
      return Result.failure('Instruction not found');
    }
  }

  @override
  Future<Result<List<ReconciliationBreak>>> fetchReconciliationCenter() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Result.success(List<ReconciliationBreak>.from(_breaks));
  }

  @override
  Future<Result<List<SettlementException>>> fetchExceptions() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Result.success(List<SettlementException>.from(_exceptions));
  }

  @override
  Future<Result<List<TreasuryPosition>>> fetchTreasuryPositions() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Result.success(List<TreasuryPosition>.from(_positions));
  }

  @override
  Future<Result<List<CounterpartyExposure>>> fetchCounterpartyExposure() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Result.success(List<CounterpartyExposure>.from(_exposures));
  }

  @override
  Future<Result<List<FinalityEvent>>> fetchFinalityTracker() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Result.success(List<FinalityEvent>.from(_events));
  }

  @override
  Future<Result<List<AuditRecord>>> fetchReportingAudit() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Result.success(List<AuditRecord>.from(_audits));
  }

  @override
  Future<Result<List<SlaMetric>>> fetchSlaMetrics() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Result.success(List<SlaMetric>.from(_metrics));
  }
}

class PostTradeRepositoryImpl implements PostTradeRepository {
  PostTradeRepositoryImpl({PostTradeDataSource? dataSource})
      : _dataSource = dataSource ?? MockPostTradeDataSource();

  final PostTradeDataSource _dataSource;

  @override
  Future<Result<PostTradeDashboardData>> fetchDashboard() {
    return _dataSource.fetchDashboard();
  }

  @override
  Future<Result<List<SettlementInstruction>>> fetchSettlementQueue() {
    return _dataSource.fetchSettlementQueue();
  }

  @override
  Future<Result<SettlementInstruction>> fetchSettlementDetail(String id) {
    return _dataSource.fetchSettlementDetail(id);
  }

  @override
  Future<Result<List<ReconciliationBreak>>> fetchReconciliationCenter() {
    return _dataSource.fetchReconciliationCenter();
  }

  @override
  Future<Result<List<SettlementException>>> fetchExceptions() {
    return _dataSource.fetchExceptions();
  }

  @override
  Future<Result<List<TreasuryPosition>>> fetchTreasuryPositions() {
    return _dataSource.fetchTreasuryPositions();
  }

  @override
  Future<Result<List<CounterpartyExposure>>> fetchCounterpartyExposure() {
    return _dataSource.fetchCounterpartyExposure();
  }

  @override
  Future<Result<List<FinalityEvent>>> fetchFinalityTracker() {
    return _dataSource.fetchFinalityTracker();
  }

  @override
  Future<Result<List<AuditRecord>>> fetchReportingAudit() {
    return _dataSource.fetchReportingAudit();
  }

  @override
  Future<Result<List<SlaMetric>>> fetchSlaMetrics() {
    return _dataSource.fetchSlaMetrics();
  }
}
