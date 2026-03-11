import 'dashboard_data.dart';
import 'home_item.dart';
import '../../../wallet/domain/entities/transaction.dart' as wallet_tx;

/// Aggregates multiple data sources for the home dashboard. Holds
/// high‑level account summaries, trending assets and recent
/// transactions. This allows the UI to access all the required
/// information through a single object rather than juggling multiple
/// cubit states.
class DashboardOverview {
  final DashboardData dashboard;
  final List<HomeItem> trending;
  final List<wallet_tx.Transaction> transactions;

  DashboardOverview(
      {required this.dashboard,
      required this.trending,
      required this.transactions});
}
