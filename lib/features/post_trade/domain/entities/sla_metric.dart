import 'package:flutter/foundation.dart';

/// Represents a service level agreement metric. Metrics capture
/// operational performance against targets for key processes
/// (e.g. settlement completion time, match rates). The [met] flag
/// indicates whether the target was achieved.
@immutable
class SlaMetric {
  final String name;
  final double value;
  final double target;
  final bool met;
  final String unit;

  const SlaMetric({
    required this.name,
    required this.value,
    required this.target,
    required this.met,
    required this.unit,
  });
}
