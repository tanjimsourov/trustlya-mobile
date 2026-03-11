import '../errors/failure.dart';

/// A lightweight success/failure wrapper used across the app.
abstract class Result<T> {
  const Result();

  const factory Result.success(T value) = Success<T>;
  const factory Result.error(String message) = Error<T>;
  const factory Result.failure(String message) = Error<T>;

  bool get isSuccess => this is Success<T>;
  bool get isError => this is Error<T>;

  T get value {
    final self = this;
    if (self is Success<T>) {
      return self.value;
    }
    throw StateError('Tried to read value from an error result.');
  }

  String? get message {
    final self = this;
    if (self is Error<T>) {
      return self.message;
    }
    return null;
  }

  T getOrElse(T Function() orElse) {
    final self = this;
    if (self is Success<T>) {
      return self.value;
    }
    return orElse();
  }

  R when<R>({
    required R Function(T value) success,
    R Function(String message)? error,
    R Function(Failure failure)? failure,
  }) {
    final self = this;
    if (self is Success<T>) {
      return success(self.value);
    }

    final message = (self as Error<T>).message;
    if (failure != null) {
      return failure(Failure(message: message));
    }
    if (error != null) {
      return error(message);
    }
    throw StateError('No failure handler provided for Result.when.');
  }
}

class Success<T> extends Result<T> {
  @override
  final T value;

  const Success(this.value);
}

class Error<T> extends Result<T> {
  @override
  final String message;

  const Error(this.message);
}
