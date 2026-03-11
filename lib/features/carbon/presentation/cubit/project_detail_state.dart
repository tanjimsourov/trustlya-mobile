import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/carbon_project_detail.dart';

/// State for the carbon project detail page.
class ProjectDetailState extends BaseState<CarbonProjectDetail?> {
  const ProjectDetailState(
      {super.status = Status.initial, super.data, super.message});

  ProjectDetailState copyWith(
      {Status? status, CarbonProjectDetail? data, String? message}) {
    return ProjectDetailState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
