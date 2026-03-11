import 'package:equatable/equatable.dart';

/// Represents the different states a cubit can be in.
enum Status { initial, loading, empty, success, error }

/// Base state class containing a status, optional data and an error message.
class BaseState<T> extends Equatable {
  final Status status;
  final T? data;
  final String? message;

  const BaseState({this.status = Status.initial, this.data, this.message});

  BaseState<T> copyWith({Status? status, T? data, String? message}) {
    return BaseState<T>(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, data, message];
}
