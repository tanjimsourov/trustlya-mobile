import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/ownership_holder.dart';

/// State for the cap table page, containing a list of ownership holders
/// for a particular programme.
class CapTableState extends BaseState<List<OwnershipHolder>?> {
  const CapTableState(
      {super.status = Status.initial, super.data, super.message});

  CapTableState copyWith(
      {Status? status, List<OwnershipHolder>? data, String? message}) {
    return CapTableState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
