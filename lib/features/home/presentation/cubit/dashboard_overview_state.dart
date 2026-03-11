import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/dashboard_overview.dart';

/// State for the [DashboardOverviewCubit]. Extends [BaseState] to
/// leverage the common status, data and message fields. The type
/// parameter is [DashboardOverview] which encapsulates multiple
/// dashboard data sources.
class DashboardOverviewState extends BaseState<DashboardOverview> {
  const DashboardOverviewState(
      {Status status = Status.initial,
      DashboardOverview? data,
      String? message})
      : super(status: status, data: data, message: message);

  DashboardOverviewState copyWith(
      {Status? status, DashboardOverview? data, String? message}) {
    return DashboardOverviewState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
