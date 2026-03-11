import 'package:equatable/equatable.dart';

/// Represents an event in the lifecycle of a tokenized asset program.
/// Examples include token distributions, dividends, buybacks and
/// corporate actions.
class LifecycleEvent extends Equatable {
  final String id;
  final String type;
  final DateTime date;
  final String description;

  const LifecycleEvent({
    required this.id,
    required this.type,
    required this.date,
    required this.description,
  });

  @override
  List<Object?> get props => [id, type, date, description];
}
