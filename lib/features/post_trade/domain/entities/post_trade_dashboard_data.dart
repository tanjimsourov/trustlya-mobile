import 'package:flutter/foundation.dart';

/// Aggregated summary metrics for the post‑trade operations dashboard.
/// Provides high level counts used by the dashboard page to
/// visualise the health and activity of settlement operations.
@immutable
class PostTradeDashboardData {
  final int totalInstructions;
  final int pendingInstructions;
  final int unresolvedBreaks;
  final int openExceptions;
  final int exposures;
  final double treasuryBalance;

  const PostTradeDashboardData({
    required this.totalInstructions,
    required this.pendingInstructions,
    required this.unresolvedBreaks,
    required this.openExceptions,
    required this.exposures,
    required this.treasuryBalance,
  });
}
