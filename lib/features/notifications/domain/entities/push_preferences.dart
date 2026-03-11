/// User preferences for push notifications.
class PushPreferences {
  final bool marketing;
  final bool productUpdates;
  final bool securityAlerts;

  PushPreferences(
      {required this.marketing,
      required this.productUpdates,
      required this.securityAlerts});
}
