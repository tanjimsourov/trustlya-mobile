import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/notification_item.dart';
import '../../domain/entities/notification_settings.dart';
import '../../domain/entities/push_preferences.dart';
import '../../domain/repositories/notifications_repository.dart';
import 'notifications_state.dart';

/// Cubit for notifications operations.
class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _repository;
  NotificationsCubit(this._repository) : super(const NotificationsState());

  Future<void> loadNotifications() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getNotifications();
    if (result is Success<List<NotificationItem>>) {
      final list = result.value;
      emit(state.copyWith(
          status: list.isEmpty ? Status.empty : Status.success, data: list));
    } else if (result is Error<List<NotificationItem>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> loadNotificationDetail(String id) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getNotificationDetail(id);
    if (result is Success<NotificationItem>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<NotificationItem>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> loadNotificationSettings() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getNotificationSettings();
    if (result is Success<NotificationSettings>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<NotificationSettings>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> loadPushPreferences() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getPushPreferences();
    if (result is Success<PushPreferences>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<PushPreferences>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
