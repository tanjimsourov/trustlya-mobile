import '../../../../core/utils/result.dart';
import '../entities/notification_item.dart';
import '../entities/notification_settings.dart';
import '../entities/push_preferences.dart';

/// Contract for notification operations.
abstract class NotificationsRepository {
  Future<Result<List<NotificationItem>>> getNotifications();
  Future<Result<NotificationItem>> getNotificationDetail(String id);
  Future<Result<NotificationSettings>> getNotificationSettings();
  Future<Result<PushPreferences>> getPushPreferences();
}
