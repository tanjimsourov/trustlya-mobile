import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/routes.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/suggestion_item.dart';
import '../../domain/repositories/suggestions_repository.dart';

abstract class SuggestionsDataSource implements SuggestionsRepository {}

class MockSuggestionsDataSource implements SuggestionsDataSource {
  final List<SuggestionItem> _suggestions = [
    SuggestionItem(
      id: 'sug_trade',
      title: 'Trade Your AK-47',
      description: 'You could upgrade your item by trading with an M9.',
      type: 'Trading',
      icon: Icons.swap_horiz,
      route: Routes.tradeBuilder,
      arguments: null,
    ),
    SuggestionItem(
      id: 'sug_topup',
      title: 'Top Up Your Balance',
      description: 'Deposit more ETH to increase your buying power.',
      type: 'Wallet',
      icon: Icons.arrow_downward,
      route: Routes.deposit,
      arguments: 'ETH',
    ),
    SuggestionItem(
      id: 'sug_game',
      title: 'Try Blackjack',
      description: 'Sharpen your skills with a round of Blackjack.',
      type: 'Casino',
      icon: Icons.casino,
      route: Routes.blackjackGame,
      arguments: null,
    ),
    SuggestionItem(
      id: 'sug_carbon',
      title: 'Offset Your Trades',
      description: 'Retire credits to balance your carbon footprint.',
      type: 'Carbon',
      icon: Icons.eco,
      route: Routes.carbonRetire,
      arguments: null,
    ),
    SuggestionItem(
      id: 'sug_kyc',
      title: 'Verify Your Identity',
      description: 'Complete KYC to unlock higher limits and bonuses.',
      type: 'General',
      icon: Icons.verified_user,
      route: Routes.kycStatus,
      arguments: null,
    ),
    SuggestionItem(
      id: 'sug_tokenise',
      title: 'Launch a Tokenization Program',
      description: 'Create and issue a new asset-backed token.',
      type: 'Enterprise',
      icon: Icons.layers,
      route: Routes.tokenizationPrograms,
      arguments: null,
    ),
    SuggestionItem(
      id: 'sug_settlement',
      title: 'Review Settlement Queue',
      description: 'Check pending settlement instructions.',
      type: 'Enterprise',
      icon: Icons.list_alt,
      route: Routes.postTradeSettlementQueue,
      arguments: null,
    ),
    SuggestionItem(
      id: 'sug_audit',
      title: 'View Audit Reports',
      description: 'Inspect post-trade audit trails and reports.',
      type: 'Enterprise',
      icon: Icons.receipt_long,
      route: Routes.postTradeReportingAudit,
      arguments: null,
    ),
  ];

  @override
  Future<Result<List<SuggestionItem>>> getSuggestions() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Result.success(List<SuggestionItem>.from(_suggestions));
  }
}

class SuggestionsRepositoryImpl implements SuggestionsRepository {
  SuggestionsRepositoryImpl({SuggestionsDataSource? dataSource})
      : _dataSource = dataSource ?? MockSuggestionsDataSource();

  final SuggestionsDataSource _dataSource;

  @override
  Future<Result<List<SuggestionItem>>> getSuggestions() {
    return _dataSource.getSuggestions();
  }
}
