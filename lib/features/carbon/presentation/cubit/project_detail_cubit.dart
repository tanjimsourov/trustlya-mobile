import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/carbon_project_detail.dart';
import '../../domain/entities/carbon_transaction.dart';
import '../../domain/repositories/carbon_repository.dart';
import 'project_detail_state.dart';

/// Cubit that loads detailed information about a carbon project and
/// manages buying credits from within the detail page.
class ProjectDetailCubit extends Cubit<ProjectDetailState> {
  final CarbonRepository _repository;
  ProjectDetailCubit(this._repository) : super(const ProjectDetailState());

  Future<void> load(String id) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getProjectDetail(id);
    if (result is Success<CarbonProjectDetail>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<CarbonProjectDetail>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  /// Purchases [quantity] credits for the project currently loaded in
  /// state. Emits loading and then success/error with the transaction.
  Future<void> buy(double quantity) async {
    final project = state.data;
    if (project == null) return;
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.buyCredits(project.id, quantity);
    if (result is Success<CarbonTransaction>) {
      // Reload project detail to reflect updated available credits
      final detailRes = await _repository.getProjectDetail(project.id);
      if (detailRes is Success<CarbonProjectDetail>) {
        emit(state.copyWith(status: Status.success, data: detailRes.value));
      } else if (detailRes is Error<CarbonProjectDetail>) {
        emit(state.copyWith(status: Status.error, message: detailRes.message));
      }
    } else if (result is Error<CarbonTransaction>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
