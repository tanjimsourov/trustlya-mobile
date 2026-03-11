import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/entities/home_item.dart';
import '../../domain/entities/news_item.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_state.dart';

/// Cubit for home feature operations.
class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;
  HomeCubit(this._repository) : super(const HomeState());

  Future<void> loadDashboard() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getDashboardData();
    if (result is Success<DashboardData>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<DashboardData>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> loadTrendingAssets() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getTrendingAssets();
    if (result is Success<List<HomeItem>>) {
      final data = result.value;
      emit(state.copyWith(
          status: data.isEmpty ? Status.empty : Status.success, data: data));
    } else if (result is Error<List<HomeItem>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> loadNews() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getNews();
    if (result is Success<List<NewsItem>>) {
      final data = result.value;
      emit(state.copyWith(
          status: data.isEmpty ? Status.empty : Status.success, data: data));
    } else if (result is Error<List<NewsItem>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> performSearch(String query) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.search(query);
    if (result is Success<List<HomeItem>>) {
      final data = result.value;
      emit(state.copyWith(
          status: data.isEmpty ? Status.empty : Status.success, data: data));
    } else if (result is Error<List<HomeItem>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
