import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/carbon_project.dart';

/// State representing a list of carbon projects loaded from the repository.
class ProjectsState extends BaseState<List<CarbonProject>?> {
  const ProjectsState(
      {super.status = Status.initial, super.data, super.message});

  ProjectsState copyWith(
      {Status? status, List<CarbonProject>? data, String? message}) {
    return ProjectsState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
