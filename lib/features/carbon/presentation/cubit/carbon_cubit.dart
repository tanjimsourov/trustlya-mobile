import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/carbon_credit.dart';
import '../../domain/entities/carbon_transaction.dart';
import '../../domain/repositories/carbon_repository.dart';
import 'carbon_state.dart';

/// Cubit for carbon credit operations.
class CarbonCubit extends Cubit<CarbonState> {
  final CarbonRepository _repository;
  CarbonCubit(this._repository) : super(const CarbonState());

  Future<void> loadMarketplace() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getMarketplace();
    if (result is Success<List<CarbonCredit>>) {
      final list = result.value;
      emit(state.copyWith(
          status: list.isEmpty ? Status.empty : Status.success, data: list));
    } else if (result is Error<List<CarbonCredit>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> loadCreditDetail(String id) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getCreditDetail(id);
    if (result is Success<CarbonCredit>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<CarbonCredit>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> buyCredits(String id, double quantity) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.buyCredits(id, quantity);
    if (result is Success<CarbonTransaction>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<CarbonTransaction>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> sellCredits(String id, double quantity) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.sellCredits(id, quantity);
    if (result is Success<CarbonTransaction>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<CarbonTransaction>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
