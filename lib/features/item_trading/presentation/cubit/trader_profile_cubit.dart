import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/trader_profile.dart';
import '../../domain/repositories/item_trading_repository.dart';
import 'trader_profile_state.dart';

/// Cubit that loads a public trader profile. It fetches the profile by
/// id from the repository and exposes it via a [TraderProfileState].
class TraderProfileCubit extends Cubit<TraderProfileState> {
  final ItemTradingRepository _repository;
  TraderProfileCubit(this._repository) : super(const TraderProfileState());

  Future<void> loadProfile(String id) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getTraderProfile(id);
    if (result is Success<TraderProfile>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<TraderProfile>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
