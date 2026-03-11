import 'package:flutter/foundation.dart';

/// Types of finality events observed during the lifecycle of a
/// settlement instruction. Each event signifies progress or issues
/// encountered as the instruction moves towards completion.
enum FinalityEventType { initiated, matched, settled, failed }

/// Represents a time‑stamped event related to the finality of a
/// settlement instruction. These events enable tracking of each
/// instruction through its lifecycle.
@immutable
class FinalityEvent {
  final String id;
  final String instructionId;
  final FinalityEventType event;
  final DateTime timestamp;

  const FinalityEvent({
    required this.id,
    required this.instructionId,
    required this.event,
    required this.timestamp,
  });
}
