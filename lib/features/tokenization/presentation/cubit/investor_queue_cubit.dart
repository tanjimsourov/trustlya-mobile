import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/onboarding_case.dart';
import '../../domain/repositories/tokenization_repository.dart';
import '../../../../core/utils/result.dart';
import 'investor_queue_state.dart';

/// Cubit for loading the investor onboarding queue.
class InvestorQueueCubit extends Cubit<InvestorQueueState> {
  final TokenizationRepository _repository;
  InvestorQueueCubit(this._repository) : super(const InvestorQueueState());

  Future<void> loadQueue() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.fetchInvestorQueue();
    if (result is Success<List<OnboardingCase>>) {
      final items = result.value;
      emit(state.copyWith(
          status: items.isEmpty ? Status.empty : Status.success, data: items));
    } else if (result is Error<List<OnboardingCase>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
