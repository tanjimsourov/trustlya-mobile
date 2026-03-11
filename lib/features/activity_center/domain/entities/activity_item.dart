import 'package:flutter/material.dart';

/// Represents a single activity event in the unified activity centre.
/// The [type] indicates which module generated the event (for example
/// Tokenization, Settlement, Wallet, or Carbon). The [title] summarises the
/// activity and [description] provides additional context. The
/// [date] indicates when the activity occurred. [icon] defines a
/// visual symbol and [color] identifies the activity type.
class ActivityItem {
  final String id;
  final String type;
  final String title;
  final String description;
  final DateTime date;
  final IconData icon;
  final Color color;

  const ActivityItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.date,
    required this.icon,
    required this.color,
  });
}
