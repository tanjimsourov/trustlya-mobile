import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/bonus.dart';
import '../../domain/repositories/casino_repository.dart';

/// State for the bonus and rewards page. Holds a list of [Bonus]
/// objects when loaded successfully.
class BonusState extends BaseState<List<Bonus>?> {
  const BonusState(
      {Status status = Status.initial, List<Bonus>? data, String? message})
      : super(status: status, data: data, message: message);

  BonusState copyWith({Status? status, List<Bonus>? data, String? message}) {
    return BonusState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}

/// Cubit to manage bonuses and rewards. It loads available bonuses and
/// allows the user to claim them. When a bonus is claimed successfully
/// the list is refreshed to reflect the updated claimable status.
class BonusCubit extends Cubit<BonusState> {
  final CasinoRepository _repository;
  BonusCubit(this._repository) : super(const BonusState());

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading));
    final res = await _repository.getBonuses();
    if (res is Success<List<Bonus>>) {
      final list = res.value;
      emit(state.copyWith(
          status: list.isEmpty ? Status.empty : Status.success, data: list));
    } else if (res is Error<List<Bonus>>) {
      emit(state.copyWith(status: Status.error, message: res.message));
    }
  }

  /// Attempts to claim the bonus with [id]. If successful, reloads the
  /// bonuses list; otherwise emits an error message.
  Future<void> claim(String id) async {
    emit(state.copyWith(status: Status.loading));
    final res = await _repository.claimBonus(id);
    if (res is Success<void>) {
      await load();
    } else if (res is Error<void>) {
      emit(state.copyWith(status: Status.error, message: res.message));
    }
  }
}
