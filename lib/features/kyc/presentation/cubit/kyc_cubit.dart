import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/kyc_status.dart';
import '../../domain/repositories/kyc_repository.dart';
import 'kyc_state.dart';

/// Cubit for KYC verification.
class KycCubit extends Cubit<KycState> {
  final KycRepository _repository;
  KycCubit(this._repository) : super(const KycState());

  Future<void> start() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.startKyc();
    if (result is Success<void>) {
      emit(state.copyWith(status: Status.success));
    } else if (result is Error<void>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> uploadIdentity(String path) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.uploadIdentity(path);
    if (result is Success<void>) {
      emit(state.copyWith(status: Status.success));
    } else if (result is Error<void>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> uploadDocument(String path) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.uploadDocument(path);
    if (result is Success<void>) {
      emit(state.copyWith(status: Status.success));
    } else if (result is Error<void>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> getStatus() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getStatus();
    if (result is Success<KycStatus>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<KycStatus>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
