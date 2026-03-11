import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/linked_method.dart';

/// State representation for the linked payout methods page. Holds a
/// list of [LinkedMethod] objects and supports loading, empty,
/// success and error statuses via [BaseState].
class LinkedMethodsState extends BaseState<List<LinkedMethod>?> {
  const LinkedMethodsState(
      {Status status = Status.initial,
      List<LinkedMethod>? data,
      String? message})
      : super(status: status, data: data, message: message);

  LinkedMethodsState copyWith(
      {Status? status, List<LinkedMethod>? data, String? message}) {
    return LinkedMethodsState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
