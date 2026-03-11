import 'dart:async';

import '../../../../core/utils/result.dart';
import '../../domain/entities/compliance_checkpoint.dart';
import '../../domain/entities/investor_profile.dart';
import '../../domain/entities/issuance_metric.dart';
import '../../domain/entities/issuance_stage.dart';
import '../../domain/entities/lifecycle_event.dart';
import '../../domain/entities/onboarding_case.dart';
import '../../domain/entities/ownership_holder.dart';
import '../../domain/entities/tokenization_activity_item.dart';
import '../../domain/entities/tokenization_overview_data.dart';
import '../../domain/entities/tokenized_asset_program.dart';
import '../../domain/repositories/tokenization_repository.dart';

abstract class TokenizationDataSource implements TokenizationRepository {}

class MockTokenizationDataSource implements TokenizationDataSource {
  final List<TokenizedAssetProgram> _programs = [
    TokenizedAssetProgram(
      id: 'prog1',
      name: 'Paris Art Tokenization',
      description:
          'Tokenising a collection of modern art pieces from renowned Parisian galleries.',
      issuanceDate: DateTime(2025, 6, 1),
      totalTokens: 1000000,
      allocatedTokens: 650000,
      status: ProgramStatus.active,
    ),
    TokenizedAssetProgram(
      id: 'prog2',
      name: 'Berlin Real Estate Tokenization',
      description:
          'Tokenising a portfolio of commercial properties across Berlin’s tech districts.',
      issuanceDate: DateTime(2026, 1, 15),
      totalTokens: 5000000,
      allocatedTokens: 3000000,
      status: ProgramStatus.planning,
    ),
    TokenizedAssetProgram(
      id: 'prog3',
      name: 'Amsterdam Renewable Energy Tokens',
      description:
          'Funding wind and solar projects through tokenised infrastructure equity.',
      issuanceDate: DateTime(2025, 9, 30),
      totalTokens: 2500000,
      allocatedTokens: 2100000,
      status: ProgramStatus.active,
    ),
  ];

  final List<InvestorProfile> _investors = [
    InvestorProfile(
      id: 'inv1',
      name: 'Sophie Dubois',
      organization: 'Dubois Ventures',
      country: 'France',
      committedAmount: 250000,
      status: InvestorStatus.approved,
    ),
    InvestorProfile(
      id: 'inv2',
      name: 'Hans Müller',
      organization: 'Müller Capital',
      country: 'Germany',
      committedAmount: 500000,
      status: InvestorStatus.pending,
    ),
    InvestorProfile(
      id: 'inv3',
      name: 'Elisa Romano',
      organization: 'Romano Family Office',
      country: 'Italy',
      committedAmount: 300000,
      status: InvestorStatus.approved,
    ),
    InvestorProfile(
      id: 'inv4',
      name: 'Lars van Dijk',
      organization: 'Van Dijk Investments',
      country: 'Netherlands',
      committedAmount: 150000,
      status: InvestorStatus.pending,
    ),
  ];

  final List<OnboardingCase> _onboardingQueue = [];
  final Map<String, List<OwnershipHolder>> _capTables = {};
  final Map<String, List<LifecycleEvent>> _lifecycleEvents = {};
  final Map<String, List<ComplianceCheckpoint>> _compliance = {};
  final Map<String, List<IssuanceMetric>> _analytics = {};
  final List<TokenizationActivityItem> _activity = [];

  MockTokenizationDataSource() {
    _onboardingQueue.addAll([
      OnboardingCase(
        id: 'case1',
        investor: _investors[1],
        status: OnboardingStatus.awaitingReview,
        submittedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      OnboardingCase(
        id: 'case2',
        investor: _investors[3],
        status: OnboardingStatus.inReview,
        submittedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ]);

    _capTables['prog1'] = [
      OwnershipHolder(
          investorName: 'Sophie Dubois', tokens: 300000, percentage: 30.0),
      OwnershipHolder(
          investorName: 'Elisa Romano', tokens: 200000, percentage: 20.0),
      OwnershipHolder(
          investorName: 'Public Float', tokens: 150000, percentage: 15.0),
    ];
    _capTables['prog2'] = [
      OwnershipHolder(
          investorName: 'Hans Müller', tokens: 1200000, percentage: 24.0),
      OwnershipHolder(
          investorName: 'Institutional Investors',
          tokens: 1800000,
          percentage: 36.0),
    ];
    _capTables['prog3'] = [
      OwnershipHolder(
          investorName: 'Lars van Dijk', tokens: 600000, percentage: 24.0),
      OwnershipHolder(
          investorName: 'Energy Co-op', tokens: 1500000, percentage: 60.0),
    ];

    _lifecycleEvents['prog1'] = [
      LifecycleEvent(
        id: 'ev1',
        type: 'Distribution',
        date: DateTime(2025, 12, 31),
        description: 'First profit distribution to token holders.',
      ),
      LifecycleEvent(
        id: 'ev2',
        type: 'Governance',
        date: DateTime(2026, 3, 15),
        description: 'Vote on curator selection.',
      ),
    ];
    _lifecycleEvents['prog2'] = [
      LifecycleEvent(
        id: 'ev3',
        type: 'Capital Call',
        date: DateTime(2026, 6, 30),
        description: 'Second capital call for property acquisition.',
      ),
    ];
    _lifecycleEvents['prog3'] = [
      LifecycleEvent(
        id: 'ev4',
        type: 'Dividend',
        date: DateTime(2025, 11, 20),
        description: 'Semi-annual dividend to renewable energy token holders.',
      ),
    ];

    _compliance['prog1'] = [
      ComplianceCheckpoint(
        id: 'cp1',
        name: 'KYC Completed',
        description: 'All investors have completed KYC/AML checks.',
        status: ComplianceStatus.passed,
      ),
      ComplianceCheckpoint(
        id: 'cp2',
        name: 'Prospectus Approved',
        description: 'Regulator has approved the offering memorandum.',
        status: ComplianceStatus.passed,
      ),
    ];
    _compliance['prog2'] = [
      ComplianceCheckpoint(
        id: 'cp3',
        name: 'Regulator Filing',
        description: 'Prospectus filed with BaFin. Approval pending.',
        status: ComplianceStatus.pending,
      ),
    ];
    _compliance['prog3'] = [
      ComplianceCheckpoint(
        id: 'cp4',
        name: 'Environmental Impact Review',
        description:
            'Impact assessments have been submitted and are under review.',
        status: ComplianceStatus.pending,
      ),
    ];

    _analytics['prog1'] = [
      IssuanceMetric(name: 'Raise Progress', value: '65%', change: 5.0),
      IssuanceMetric(name: 'Investor Count', value: '120', change: 2.0),
      IssuanceMetric(name: 'Token Price', value: '€1.20', change: 0.03),
    ];
    _analytics['prog2'] = [
      IssuanceMetric(name: 'Raise Progress', value: '60%', change: 10.0),
      IssuanceMetric(name: 'Investor Count', value: '85', change: -1.0),
    ];
    _analytics['prog3'] = [
      IssuanceMetric(name: 'Raise Progress', value: '84%', change: 2.5),
      IssuanceMetric(name: 'Investor Count', value: '200', change: 5.0),
    ];

    _activity.addAll([
      TokenizationActivityItem(
        id: 'act1',
        title: 'Hans Müller joined Berlin Real Estate programme',
        description: 'Pending investment of €500K awaiting approval.',
        date: DateTime.now().subtract(const Duration(hours: 5)),
        type: 'InvestorOnboarding',
      ),
      TokenizationActivityItem(
        id: 'act2',
        title: 'Dividend distributed to Amsterdam Renewable Energy tokens',
        description: '€0.05 per token paid to holders.',
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: 'Distribution',
      ),
      TokenizationActivityItem(
        id: 'act3',
        title: 'New capital call announced for Berlin Real Estate',
        description: 'Investors notified of upcoming capital requirements.',
        date: DateTime.now().subtract(const Duration(days: 3)),
        type: 'CapitalCall',
      ),
    ]);
  }

  @override
  Future<Result<TokenizationOverviewData>> fetchOverview() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final total = _programs.length;
    final active = _programs
        .where((program) => program.status == ProgramStatus.active)
        .length;
    final investors = _investors.length;
    final pending = _onboardingQueue
        .where((item) => item.status != OnboardingStatus.completed)
        .length;
    return Result.success(TokenizationOverviewData(
      totalPrograms: total,
      activePrograms: active,
      investors: investors,
      pendingOnboardings: pending,
    ));
  }

  @override
  Future<Result<List<TokenizedAssetProgram>>> fetchPrograms() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Result.success(List<TokenizedAssetProgram>.from(_programs));
  }

  @override
  Future<Result<TokenizedAssetProgram>> fetchProgramDetail(
      String programId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final program = _programs.firstWhere((item) => item.id == programId,
        orElse: () => _programs.first);
    return Result.success(program);
  }

  @override
  Future<Result<List<IssuanceStage>>> fetchIssuanceWorkflow(
      String programId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Result.success([
      IssuanceStage(
        id: 'stage1',
        name: 'Structuring',
        description: 'Define terms, structure and regulatory pathway.',
        status: StageStatus.completed,
        dueDate: DateTime.now().subtract(const Duration(days: 90)),
      ),
      IssuanceStage(
        id: 'stage2',
        name: 'Regulatory Approval',
        description:
            'Submit documentation for approval from competent authority.',
        status: StageStatus.inProgress,
        dueDate: DateTime.now().add(const Duration(days: 30)),
      ),
      IssuanceStage(
        id: 'stage3',
        name: 'Token Generation',
        description: 'Deploy smart contracts and mint tokens.',
        status: StageStatus.pending,
        dueDate: DateTime.now().add(const Duration(days: 60)),
      ),
      IssuanceStage(
        id: 'stage4',
        name: 'Distribution',
        description:
            'Distribute tokens to investors and list on approved venues.',
        status: StageStatus.pending,
        dueDate: DateTime.now().add(const Duration(days: 90)),
      ),
    ]);
  }

  @override
  Future<Result<List<OnboardingCase>>> fetchInvestorQueue() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Result.success(List<OnboardingCase>.from(_onboardingQueue));
  }

  @override
  Future<Result<List<OwnershipHolder>>> fetchCapTable(String programId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Result.success(
        List<OwnershipHolder>.from(_capTables[programId] ?? []));
  }

  @override
  Future<Result<List<LifecycleEvent>>> fetchLifecycleEvents(
      String programId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Result.success(
      List<LifecycleEvent>.from(_lifecycleEvents[programId] ?? []),
    );
  }

  @override
  Future<Result<List<ComplianceCheckpoint>>> fetchComplianceReadiness(
      String programId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Result.success(
      List<ComplianceCheckpoint>.from(_compliance[programId] ?? []),
    );
  }

  @override
  Future<Result<List<IssuanceMetric>>> fetchIssuanceAnalytics(
      String programId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Result.success(
        List<IssuanceMetric>.from(_analytics[programId] ?? []));
  }

  @override
  Future<Result<List<TokenizationActivityItem>>> fetchActivity() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Result.success(List<TokenizationActivityItem>.from(_activity));
  }
}

class TokenizationRepositoryImpl implements TokenizationRepository {
  TokenizationRepositoryImpl({TokenizationDataSource? dataSource})
      : _dataSource = dataSource ?? MockTokenizationDataSource();

  final TokenizationDataSource _dataSource;

  @override
  Future<Result<TokenizationOverviewData>> fetchOverview() {
    return _dataSource.fetchOverview();
  }

  @override
  Future<Result<List<TokenizedAssetProgram>>> fetchPrograms() {
    return _dataSource.fetchPrograms();
  }

  @override
  Future<Result<TokenizedAssetProgram>> fetchProgramDetail(String programId) {
    return _dataSource.fetchProgramDetail(programId);
  }

  @override
  Future<Result<List<IssuanceStage>>> fetchIssuanceWorkflow(String programId) {
    return _dataSource.fetchIssuanceWorkflow(programId);
  }

  @override
  Future<Result<List<OnboardingCase>>> fetchInvestorQueue() {
    return _dataSource.fetchInvestorQueue();
  }

  @override
  Future<Result<List<OwnershipHolder>>> fetchCapTable(String programId) {
    return _dataSource.fetchCapTable(programId);
  }

  @override
  Future<Result<List<LifecycleEvent>>> fetchLifecycleEvents(String programId) {
    return _dataSource.fetchLifecycleEvents(programId);
  }

  @override
  Future<Result<List<ComplianceCheckpoint>>> fetchComplianceReadiness(
      String programId) {
    return _dataSource.fetchComplianceReadiness(programId);
  }

  @override
  Future<Result<List<IssuanceMetric>>> fetchIssuanceAnalytics(
      String programId) {
    return _dataSource.fetchIssuanceAnalytics(programId);
  }

  @override
  Future<Result<List<TokenizationActivityItem>>> fetchActivity() {
    return _dataSource.fetchActivity();
  }
}
