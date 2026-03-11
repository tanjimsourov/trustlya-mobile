import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/carbon_project.dart';
import '../../domain/repositories/carbon_repository.dart';
import 'projects_state.dart';

/// Cubit that loads a list of carbon projects, optionally filtered by
/// category. Projects are displayed in the marketplace listing.
class ProjectsCubit extends Cubit<ProjectsState> {
  final CarbonRepository _repository;
  ProjectsCubit(this._repository) : super(const ProjectsState());

  Future<void> load({String? category}) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getProjects(category: category);
    if (result is Success<List<CarbonProject>>) {
      final list = result.value;
      emit(state.copyWith(
          status: list.isEmpty ? Status.empty : Status.success, data: list));
    } else if (result is Error<List<CarbonProject>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
