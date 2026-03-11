/// Represents a device that has been marked as trusted for login. Stores
/// a friendly name for the device and the last time it was active.
class TrustedDevice {
  final String name;
  final DateTime lastActive;

  TrustedDevice({required this.name, required this.lastActive});
}
