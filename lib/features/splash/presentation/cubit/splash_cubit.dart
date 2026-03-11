import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/cubit/base_state.dart';

/// Cubit controlling the splash flow. It waits for a short
/// duration before emitting whether the user is logged in. For now
/// authentication always returns false as this is a mock implementation.
class SplashCubit extends Cubit<BaseState<bool>> {
  SplashCubit() : super(const BaseState(status: Status.initial));

  /// Starts the splash timer and emits a success state after a delay.
  /// The [data] of the emitted state indicates whether the user is
  /// already logged in. In a real implementation this would check
  /// persisted auth tokens or secure storage.
  void initialize() {
    emit(state.copyWith(status: Status.loading));
    // Simulate some loading and decision making. After the delay
    // we emit a success state with `false` meaning the user is not
    // authenticated.
    Timer(const Duration(seconds: 2), () {
      emit(state.copyWith(status: Status.success, data: false));
    });
  }
}
