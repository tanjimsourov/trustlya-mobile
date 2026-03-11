import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/cubit/base_state.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/audit_record.dart';
import '../../domain/repositories/post_trade_repository.dart';
import 'reporting_audit_state.dart';

/// Cubit responsible for loading audit trail records. Exposes a
/// method to fetch audit data from the repository.
class ReportingAuditCubit extends Cubit<ReportingAuditState> {
  final PostTradeRepository _repository;
  ReportingAuditCubit(this._repository) : super(const ReportingAuditState());

  Future<void> loadAudit() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.fetchReportingAudit();
    if (result is Success<List<AuditRecord>>) {
      final list = result.value;
      if (list.isEmpty) {
        emit(state.copyWith(status: Status.empty, data: []));
      } else {
        emit(state.copyWith(status: Status.success, data: list));
      }
    } else if (result is Error<List<AuditRecord>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
