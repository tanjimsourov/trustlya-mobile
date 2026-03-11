import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';

/// State for home feature. Holds dynamic data which can be either
/// [DashboardData], [List<HomeItem>] or [List<NewsItem>].
class HomeState extends BaseState<dynamic> {
  const HomeState({super.status = Status.initial, super.data, super.message});

  HomeState copyWith({Status? status, dynamic data, String? message}) {
    return HomeState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
