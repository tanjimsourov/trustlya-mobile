import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/post_trade_dashboard_data.dart';

/// State for the postâ€‘trade dashboard. Holds high level summary
/// metrics used to populate the dashboard page.
class PostTradeDashboardState extends BaseState<PostTradeDashboardData?> {
  const PostTradeDashboardState(
      {super.status = Status.initial, super.data, super.message});

  PostTradeDashboardState copyWith(
      {Status? status, PostTradeDashboardData? data, String? message}) {
    return PostTradeDashboardState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
