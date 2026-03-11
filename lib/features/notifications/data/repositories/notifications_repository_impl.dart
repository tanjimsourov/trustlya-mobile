import 'dart:async';

import '../../../../core/utils/result.dart';
import '../../domain/entities/notification_item.dart';
import '../../domain/entities/notification_settings.dart';
import '../../domain/entities/push_preferences.dart';
import '../../domain/repositories/notifications_repository.dart';

abstract class NotificationsDataSource implements NotificationsRepository {}

class MockNotificationsDataSource implements NotificationsDataSource {
  final List<NotificationItem> _notifications = [
    NotificationItem(
        id: '1',
        title: 'Order Executed',
        body: 'Your BTC order was executed.',
        date: DateTime.now().subtract(const Duration(hours: 2))),
    NotificationItem(
        id: '2',
        title: 'New Game Release',
        body: 'Check out the new slots game!',
        date: DateTime.now().subtract(const Duration(days: 1))),
  ];

  final NotificationSettings _settings =
      NotificationSettings(pushEnabled: true, emailEnabled: false);

  final PushPreferences _preferences = PushPreferences(
      marketing: true, productUpdates: true, securityAlerts: true);

  @override
  Future<Result<List<NotificationItem>>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(_notifications);
  }

  @override
  Future<Result<NotificationItem>> getNotificationDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final notification = _notifications.firstWhere((n) => n.id == id,
        orElse: () => _notifications.first);
    return Result.success(notification);
  }

  @override
  Future<Result<NotificationSettings>> getNotificationSettings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(_settings);
  }

  @override
  Future<Result<PushPreferences>> getPushPreferences() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(_preferences);
  }
}

class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl({NotificationsDataSource? dataSource})
      : _dataSource = dataSource ?? MockNotificationsDataSource();

  final NotificationsDataSource _dataSource;

  @override
  Future<Result<List<NotificationItem>>> getNotifications() {
    return _dataSource.getNotifications();
  }

  @override
  Future<Result<NotificationItem>> getNotificationDetail(String id) {
    return _dataSource.getNotificationDetail(id);
  }

  @override
  Future<Result<NotificationSettings>> getNotificationSettings() {
    return _dataSource.getNotificationSettings();
  }

  @override
  Future<Result<PushPreferences>> getPushPreferences() {
    return _dataSource.getPushPreferences();
  }
}
