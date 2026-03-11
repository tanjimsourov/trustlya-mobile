import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/audit_record.dart';

/// State for the reporting & audit page. Holds a list of audit
/// records used for compliance and operational analysis.
class ReportingAuditState extends BaseState<List<AuditRecord>?> {
  const ReportingAuditState(
      {super.status = Status.initial, super.data, super.message});

  ReportingAuditState copyWith(
      {Status? status, List<AuditRecord>? data, String? message}) {
    return ReportingAuditState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
