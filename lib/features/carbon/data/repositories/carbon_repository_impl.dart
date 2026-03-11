import 'dart:async';
import 'dart:math';

import '../../../../core/utils/result.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/carbon_credit.dart';
import '../../domain/entities/carbon_holding.dart';
import '../../domain/entities/carbon_project.dart';
import '../../domain/entities/carbon_project_detail.dart';
import '../../domain/entities/carbon_transaction.dart';
import '../../domain/entities/impact_analytics.dart';
import '../../domain/entities/marketplace_dashboard_data.dart';
import '../../domain/repositories/carbon_repository.dart';

abstract class CarbonDataSource implements CarbonRepository {}

class MockCarbonDataSource implements CarbonDataSource {
  final Random _rand = Random();

  final List<CarbonProjectDetail> _projects = [
    CarbonProjectDetail(
      id: 'proj1',
      name: 'Baltic Peatland Restoration Reserve',
      location: 'Parnu County, Estonia',
      badges: ['Verra', 'Gold Standard'],
      pricePerCredit: 14.8,
      category: 'Reforestation',
      imageUrl: '',
      story:
          'Restores degraded peatland parcels and woodland buffers across a multi-year conservation program with registry-backed issuance controls.',
      verificationInfo:
          'Verified under Verra and Gold Standard methodologies with annual field review, buffer pool coverage, and third-party MRV controls.',
      priceHistory: [
        13.9,
        14.0,
        14.2,
        14.1,
        14.4,
        14.6,
        14.7,
        14.9,
        14.8,
        14.9,
        14.8,
        14.8,
      ],
      availableCredits: 11800,
    ),
    CarbonProjectDetail(
      id: 'proj2',
      name: 'Andalusia Solar Grid Expansion',
      location: 'Seville, Spain',
      badges: ['Verra', 'ICROA'],
      pricePerCredit: 10.9,
      category: 'Renewable Energy',
      imageUrl: '',
      story:
          'Funds an additional solar generation tranche tied to grid balancing infrastructure and auditable renewable output reporting.',
      verificationInfo:
          'Registry-approved renewable generation credits with documented issuance cadence, production audit evidence, and retirement traceability.',
      priceHistory: [
        10.1,
        10.2,
        10.3,
        10.4,
        10.5,
        10.7,
        10.6,
        10.8,
        10.9,
        11.0,
        10.9,
        10.9,
      ],
      availableCredits: 16400,
    ),
    CarbonProjectDetail(
      id: 'proj3',
      name: 'Sumatra Mangrove Blue Carbon Facility',
      location: 'Aceh, Indonesia',
      badges: ['Verra', 'Blue Carbon'],
      pricePerCredit: 18.2,
      category: 'Blue Carbon',
      imageUrl: '',
      story:
          'Supports mangrove restoration and shoreline resilience with tokenized project inventory aligned to verified blue carbon methodologies.',
      verificationInfo:
          'Third-party verified blue carbon methodology with biodiversity co-benefit evidence, issuance controls, and retirement-grade documentation.',
      priceHistory: [
        17.1,
        17.3,
        17.5,
        17.8,
        18.0,
        18.3,
        18.4,
        18.3,
        18.2,
        18.4,
        18.3,
        18.2,
      ],
      availableCredits: 6200,
    ),
    CarbonProjectDetail(
      id: 'proj4',
      name: 'Iberian Forest Fire Recovery Program',
      location: 'Castile and Leon, Spain',
      badges: ['Gold Standard', 'Nature'],
      pricePerCredit: 16.4,
      category: 'Reforestation',
      imageUrl: '',
      story:
          'Rebuilds fire-damaged woodland acreage and watershed protection corridors through staged credit issuance and monitored replanting milestones.',
      verificationInfo:
          'Registry-backed restoration methodology with issuance checkpoints, satellite verification, and annual survivability monitoring.',
      priceHistory: [
        15.6,
        15.7,
        15.9,
        16.0,
        16.2,
        16.1,
        16.3,
        16.4,
        16.5,
        16.4,
        16.3,
        16.4,
      ],
      availableCredits: 9100,
    ),
  ];

  final List<CarbonHolding> _holdings = [
    CarbonHolding(
      projectId: 'proj1',
      projectName: 'Baltic Peatland Restoration Reserve',
      quantity: 2800,
      pricePerCredit: 14.8,
      retired: false,
    ),
    CarbonHolding(
      projectId: 'proj3',
      projectName: 'Sumatra Mangrove Blue Carbon Facility',
      quantity: 950,
      pricePerCredit: 18.2,
      retired: false,
    ),
    CarbonHolding(
      projectId: 'proj2',
      projectName: 'Andalusia Solar Grid Expansion',
      quantity: 1200,
      pricePerCredit: 10.9,
      retired: true,
    ),
  ];

  final List<CarbonTransaction> _transactions = [
    CarbonTransaction(
      id: 'ctx-1001',
      projectName: 'Baltic Peatland Restoration Reserve',
      quantity: 1800,
      pricePerCredit: 14.4,
      type: 'buy',
      date: _daysAgo(18),
      status: 'completed',
    ),
    CarbonTransaction(
      id: 'ctx-1002',
      projectName: 'Andalusia Solar Grid Expansion',
      quantity: 1200,
      pricePerCredit: 10.5,
      type: 'buy',
      date: _daysAgo(11),
      status: 'completed',
    ),
    CarbonTransaction(
      id: 'ctx-1003',
      projectName: 'Andalusia Solar Grid Expansion',
      quantity: 1200,
      pricePerCredit: 10.5,
      type: 'retire',
      date: _daysAgo(7),
      status: 'completed',
    ),
    CarbonTransaction(
      id: 'ctx-1004',
      projectName: 'Baltic Peatland Restoration Reserve',
      quantity: 1000,
      pricePerCredit: 14.8,
      type: 'buy',
      date: _daysAgo(3),
      status: 'completed',
    ),
    CarbonTransaction(
      id: 'ctx-1005',
      projectName: 'Sumatra Mangrove Blue Carbon Facility',
      quantity: 950,
      pricePerCredit: 18.2,
      type: 'buy',
      date: _daysAgo(2),
      status: 'completed',
    ),
  ];

  final List<Achievement> _achievements = [
    Achievement(
      id: 'ach1',
      title: 'First Retirement',
      description:
          'Retire the first verified carbon position from the marketplace.',
      progress: 0.0,
      achieved: false,
    ),
    Achievement(
      id: 'ach2',
      title: '10 Tonnes Offset',
      description: 'Retire a cumulative 10 tonnes of verified credits.',
      progress: 0.0,
      achieved: false,
    ),
    Achievement(
      id: 'ach3',
      title: '50 Tonnes Offset',
      description: 'Retire a cumulative 50 tonnes of verified credits.',
      progress: 0.0,
      achieved: false,
    ),
  ];

  double get _totalOffset => _transactions
      .where((transaction) => transaction.type == 'retire')
      .fold(0.0, (sum, transaction) => sum + transaction.quantity);

  @override
  Future<Result<List<CarbonCredit>>> getMarketplace() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Result.success(
      _projects
          .map(
            (project) => CarbonCredit(
              id: project.id,
              name: project.name,
              price: project.pricePerCredit,
              availableQuantity: project.availableCredits,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<Result<CarbonCredit>> getCreditDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final project = _projects.firstWhere((item) => item.id == id,
        orElse: () => _projects.first);
    return Result.success(
      CarbonCredit(
        id: project.id,
        name: project.name,
        price: project.pricePerCredit,
        availableQuantity: project.availableCredits,
      ),
    );
  }

  @override
  Future<Result<CarbonTransaction>> sellCredits(
      String id, double quantity) async {
    return retireCredits(id, quantity);
  }

  @override
  Future<Result<MarketplaceDashboardData>> getDashboardData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final totalCredits = _holdings
        .where((holding) => !holding.retired)
        .fold<double>(0.0, (sum, holding) => sum + holding.quantity);
    final featured =
        _projects.take(3).map((project) => project as CarbonProject).toList();
    final prices = {
      for (final project in _projects) project.id: project.pricePerCredit,
    };
    return Result.success(
      MarketplaceDashboardData(
        totalCreditsHeld: totalCredits,
        totalImpact: _totalOffset,
        featuredProjects: featured,
        latestPrices: prices,
      ),
    );
  }

  @override
  Future<Result<List<CarbonProject>>> getProjects({String? category}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final filtered = category == null
        ? _projects
        : _projects
            .where((project) =>
                project.category.toLowerCase() == category.toLowerCase())
            .toList();
    return Result.success(List<CarbonProject>.from(filtered));
  }

  @override
  Future<Result<CarbonProjectDetail>> getProjectDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final project = _projects.firstWhere((item) => item.id == id,
        orElse: () => _projects.first);
    return Result.success(project);
  }

  @override
  Future<Result<List<CarbonHolding>>> getHoldings() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Result.success(List<CarbonHolding>.from(_holdings));
  }

  @override
  Future<Result<List<CarbonTransaction>>> getTransactionHistory() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final sorted = List<CarbonTransaction>.from(_transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    return Result.success(sorted);
  }

  @override
  Future<Result<CarbonTransaction>> buyCredits(
      String projectId, double quantity) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final projectIndex =
        _projects.indexWhere((project) => project.id == projectId);
    if (projectIndex < 0) {
      return Result.error('Project not found');
    }

    final project = _projects[projectIndex];
    if (quantity <= 0) {
      return Result.error('Enter a valid quantity');
    }
    if (quantity > project.availableCredits) {
      return Result.error('Not enough credits available');
    }

    final updatedProject =
        project.copyWith(availableCredits: project.availableCredits - quantity);
    _projects[projectIndex] = updatedProject;

    final holdingIndex = _holdings.indexWhere(
      (holding) => holding.projectId == projectId && !holding.retired,
    );
    if (holdingIndex >= 0) {
      final currentHolding = _holdings[holdingIndex];
      _holdings[holdingIndex] = currentHolding.copyWith(
        quantity: currentHolding.quantity + quantity,
        pricePerCredit: updatedProject.pricePerCredit,
      );
    } else {
      _holdings.add(
        CarbonHolding(
          projectId: updatedProject.id,
          projectName: updatedProject.name,
          quantity: quantity,
          pricePerCredit: updatedProject.pricePerCredit,
          retired: false,
        ),
      );
    }

    final transaction = CarbonTransaction(
      id: 'ctx-${DateTime.now().millisecondsSinceEpoch}',
      projectName: updatedProject.name,
      quantity: quantity,
      pricePerCredit: updatedProject.pricePerCredit,
      type: 'buy',
      date: DateTime.now(),
      status: 'completed',
    );
    _transactions.add(transaction);
    return Result.success(transaction);
  }

  @override
  Future<Result<CarbonTransaction>> retireCredits(
      String projectId, double quantity,
      {String? reason}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final holdingIndex = _holdings.indexWhere(
      (holding) => holding.projectId == projectId && !holding.retired,
    );
    if (holdingIndex < 0) {
      return Result.error('No holdings for the selected project');
    }

    final holding = _holdings[holdingIndex];
    if (quantity <= 0) {
      return Result.error('Enter a valid quantity');
    }
    if (quantity > holding.quantity) {
      return Result.error('Insufficient quantity to retire');
    }

    final remaining = holding.quantity - quantity;
    if (remaining <= 0) {
      _holdings[holdingIndex] = holding.copyWith(quantity: 0, retired: true);
    } else {
      _holdings[holdingIndex] = holding.copyWith(quantity: remaining);
    }

    final project = _projects.firstWhere((item) => item.id == projectId,
        orElse: () => _projects.first);
    final transaction = CarbonTransaction(
      id: 'ctx-${DateTime.now().millisecondsSinceEpoch}',
      projectName: project.name,
      quantity: quantity,
      pricePerCredit: project.pricePerCredit,
      type: 'retire',
      date: DateTime.now(),
      status: 'completed',
    );
    _transactions.add(transaction);
    return Result.success(transaction);
  }

  @override
  Future<Result<ImpactAnalytics>> getImpactAnalytics() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final total = _totalOffset;
    final monthly = List<double>.generate(
      12,
      (_) => total == 0 ? 0 : (total / 12) * (0.8 + _rand.nextDouble() * 0.4),
    );
    final yearly = List<double>.generate(
      5,
      (index) => total == 0
          ? 0
          : (total / (index + 3)) * (0.8 + _rand.nextDouble() * 0.4),
    ).reversed.toList();

    final breakdown = <String, double>{};
    for (final transaction
        in _transactions.where((item) => item.type == 'retire')) {
      breakdown[transaction.projectName] =
          (breakdown[transaction.projectName] ?? 0) + transaction.quantity;
    }

    return Result.success(
      ImpactAnalytics(
        totalOffset: total,
        monthlyData: monthly,
        yearlyData: yearly,
        projectBreakdown: breakdown,
      ),
    );
  }

  @override
  Future<Result<List<Achievement>>> getAchievements() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final total = _totalOffset;
    final thresholds = [1.0, 10.0, 50.0];
    final updated = <Achievement>[];

    for (var index = 0; index < _achievements.length; index++) {
      final achievement = _achievements[index];
      final progress = (total / thresholds[index]).clamp(0.0, 1.0);
      updated.add(
        Achievement(
          id: achievement.id,
          title: achievement.title,
          description: achievement.description,
          progress: progress,
          achieved: progress >= 1.0,
        ),
      );
    }

    return Result.success(updated);
  }
}

class CarbonRepositoryImpl implements CarbonRepository {
  CarbonRepositoryImpl({CarbonDataSource? dataSource})
      : _dataSource = dataSource ?? MockCarbonDataSource();

  final CarbonDataSource _dataSource;

  @override
  Future<Result<List<CarbonCredit>>> getMarketplace() {
    return _dataSource.getMarketplace();
  }

  @override
  Future<Result<CarbonCredit>> getCreditDetail(String id) {
    return _dataSource.getCreditDetail(id);
  }

  @override
  Future<Result<CarbonTransaction>> buyCredits(
      String projectId, double quantity) {
    return _dataSource.buyCredits(projectId, quantity);
  }

  @override
  Future<Result<CarbonTransaction>> sellCredits(String id, double quantity) {
    return _dataSource.sellCredits(id, quantity);
  }

  @override
  Future<Result<MarketplaceDashboardData>> getDashboardData() {
    return _dataSource.getDashboardData();
  }

  @override
  Future<Result<List<CarbonProject>>> getProjects({String? category}) {
    return _dataSource.getProjects(category: category);
  }

  @override
  Future<Result<CarbonProjectDetail>> getProjectDetail(String id) {
    return _dataSource.getProjectDetail(id);
  }

  @override
  Future<Result<List<CarbonHolding>>> getHoldings() {
    return _dataSource.getHoldings();
  }

  @override
  Future<Result<CarbonTransaction>> retireCredits(
      String projectId, double quantity,
      {String? reason}) {
    return _dataSource.retireCredits(projectId, quantity, reason: reason);
  }

  @override
  Future<Result<List<CarbonTransaction>>> getTransactionHistory() {
    return _dataSource.getTransactionHistory();
  }

  @override
  Future<Result<ImpactAnalytics>> getImpactAnalytics() {
    return _dataSource.getImpactAnalytics();
  }

  @override
  Future<Result<List<Achievement>>> getAchievements() {
    return _dataSource.getAchievements();
  }
}

DateTime _daysAgo(int days) => DateTime.now().subtract(Duration(days: days));
