import 'dart:async';

import '../../../../core/utils/result.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/repositories/search_repository.dart';
import '../../../../app/routes.dart';
import 'package:flutter/material.dart';

/// Mock implementation of [SearchRepository]. It aggregates search
/// results from the different modules of the app. For demonstration,
/// it generates a static list of results and performs simple
/// filtering. Recent searches are stored in memory.
class SearchRepositoryImpl implements SearchRepository {
  final List<String> _recent = [];

  // Predefined search data. In a real implementation, this data
  // would come from other repositories or a backend service. Each
  // entry includes a type, route and optional arguments for
  // navigation.
  final List<SearchResult> _data = [
    // Wallet assets
    SearchResult(
      id: 'BTC',
      title: 'Bitcoin (BTC)',
      subtitle: 'Asset',
      type: 'Assets',
      icon: Icons.currency_bitcoin,
      route: Routes.walletAssetDetail,
      arguments: 'BTC',
    ),
    SearchResult(
      id: 'ETH',
      title: 'Ethereum (ETH)',
      subtitle: 'Asset',
      type: 'Assets',
      icon: Icons.token,
      route: Routes.walletAssetDetail,
      arguments: 'ETH',
    ),
    // Trading items
    SearchResult(
      id: 'ak_redline',
      title: 'AK‑47 Redline',
      subtitle: 'CS:GO Item',
      type: 'Items',
      icon: Icons.sports_esports,
      route: Routes.itemDetail,
      arguments: 'ak_redline',
    ),
    SearchResult(
      id: 'm9_lore',
      title: 'M9 Bayonet Lore',
      subtitle: 'CS:GO Item',
      type: 'Items',
      // Use a general gaming icon since the Material icon set does not include a swords icon.
      icon: Icons.sports_esports,
      route: Routes.itemDetail,
      arguments: 'm9_lore',
    ),
    // Casino games
    SearchResult(
      id: 'slots',
      title: 'Slots Game',
      subtitle: 'Casino',
      type: 'Games',
      icon: Icons.casino,
      route: Routes.slotsGame,
    ),
    SearchResult(
      id: 'roulette',
      title: 'Roulette',
      subtitle: 'Casino',
      type: 'Games',
      icon: Icons.change_circle,
      route: Routes.rouletteGame,
    ),
    // Carbon projects
    SearchResult(
      id: 'proj1',
      title: 'Rainforest Preservation',
      subtitle: 'Carbon Project',
      type: 'Carbon',
      icon: Icons.eco,
      route: Routes.carbonProjectDetail,
      arguments: 'proj1',
    ),
    SearchResult(
      id: 'proj2',
      title: 'Wind Farm Expansion',
      subtitle: 'Carbon Project',
      type: 'Carbon',
      icon: Icons.wind_power,
      route: Routes.carbonProjectDetail,
      arguments: 'proj2',
    ),
    // Recent transactions (mock)
    SearchResult(
      id: 'tx1',
      title: 'Transaction #1',
      subtitle: 'Deposit 0.5 BTC',
      type: 'Transactions',
      icon: Icons.swap_vert,
      route: Routes.transactionHistory,
    ),
    SearchResult(
      id: 'tx2',
      title: 'Trade Completed',
      subtitle: 'Traded AK‑47 for M9 Lore',
      type: 'Transactions',
      icon: Icons.history,
      route: Routes.tradeHistory,
    ),

    // ------------------------------------------------------------------
    // Tokenisation search results
    SearchResult(
      id: 'tokenisation_overview',
      title: 'Tokenisation Hub',
      subtitle: 'Enterprise',
      type: 'Tokenisation',
      icon: Icons.layers,
      route: Routes.tokenizationOverview,
      arguments: null,
    ),
    SearchResult(
      id: 'tokenisation_programs',
      title: 'Asset Programs',
      subtitle: 'Tokenisation',
      type: 'Tokenisation',
      icon: Icons.folder_special,
      route: Routes.tokenizationPrograms,
      arguments: null,
    ),
    SearchResult(
      id: 'tokenisation_investor_queue',
      title: 'Investor Onboarding Queue',
      subtitle: 'Tokenisation',
      type: 'Tokenisation',
      icon: Icons.people_outline,
      route: Routes.tokenizationInvestorQueue,
      arguments: null,
    ),
    SearchResult(
      id: 'tokenisation_analytics',
      title: 'Issuance Analytics',
      subtitle: 'Tokenisation',
      type: 'Tokenisation',
      icon: Icons.bar_chart,
      route: Routes.tokenizationAnalytics,
      arguments: null,
    ),

    // ------------------------------------------------------------------
    // Post‑trade search results (Settlement)
    SearchResult(
      id: 'settlement_dashboard',
      title: 'Post‑Trade Dashboard',
      subtitle: 'Settlement',
      type: 'Settlement',
      icon: Icons.dashboard,
      route: Routes.postTradeDashboard,
      arguments: null,
    ),
    SearchResult(
      id: 'settlement_queue',
      title: 'Settlement Queue',
      subtitle: 'Settlement',
      type: 'Settlement',
      icon: Icons.list_alt,
      route: Routes.postTradeSettlementQueue,
      arguments: null,
    ),
    SearchResult(
      id: 'reconciliation_center',
      title: 'Reconciliation Center',
      subtitle: 'Settlement',
      type: 'Settlement',
      icon: Icons.compare_arrows,
      route: Routes.postTradeReconciliation,
      arguments: null,
    ),
    SearchResult(
      id: 'exceptions_breaks',
      title: 'Exceptions & Breaks',
      subtitle: 'Settlement',
      type: 'Settlement',
      icon: Icons.error_outline,
      route: Routes.postTradeExceptions,
      arguments: null,
    ),
    SearchResult(
      id: 'treasury_positioning',
      title: 'Treasury Positioning',
      subtitle: 'Settlement',
      type: 'Settlement',
      icon: Icons.account_balance,
      route: Routes.postTradeTreasury,
      arguments: null,
    ),
    SearchResult(
      id: 'counterparty_exposure',
      title: 'Counterparty Exposure',
      subtitle: 'Settlement',
      type: 'Settlement',
      icon: Icons.assessment,
      route: Routes.postTradeExposure,
      arguments: null,
    ),
    SearchResult(
      id: 'finality_tracker',
      title: 'Finality Tracker',
      subtitle: 'Settlement',
      type: 'Settlement',
      icon: Icons.timeline,
      route: Routes.postTradeFinalityTracker,
      arguments: null,
    ),
    SearchResult(
      id: 'reporting_audit',
      title: 'Reporting & Audit',
      subtitle: 'Settlement',
      type: 'Settlement',
      icon: Icons.receipt_long,
      route: Routes.postTradeReportingAudit,
      arguments: null,
    ),
    SearchResult(
      id: 'sla_monitoring',
      title: 'SLA Monitoring',
      subtitle: 'Settlement',
      type: 'Settlement',
      icon: Icons.speed,
      route: Routes.postTradeSlaMonitoring,
      arguments: null,
    ),
  ];

  @override
  Future<Result<List<SearchResult>>> search(String query,
      {String? category}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final q = query.toLowerCase();
    final filtered = _data.where((res) {
      final matchesQuery = res.title.toLowerCase().contains(q) ||
          (res.subtitle?.toLowerCase().contains(q) ?? false);
      final matchesCategory =
          category == null || category == 'All' || res.type == category;
      return matchesQuery && matchesCategory;
    }).toList();
    return Result.success(filtered);
  }

  @override
  Future<Result<List<String>>> getRecentSearches() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return Result.success(List<String>.from(_recent.reversed));
  }

  @override
  Future<Result<List<String>>> getSuggestedSearches() async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Simple suggestions derived from titles of results
    final suggestions =
        _data.take(5).map((r) => r.title.split(' ').first).toSet().toList();
    return Result.success(suggestions);
  }

  @override
  Future<void> saveSearch(String term) async {
    if (term.isEmpty) return;
    _recent.removeWhere((e) => e.toLowerCase() == term.toLowerCase());
    _recent.add(term);
    // Cap at 5 recent searches
    if (_recent.length > 5) {
      _recent.removeAt(0);
    }
  }
}
