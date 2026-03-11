import 'package:equatable/equatable.dart';

/// Represents a step in the token issuance workflow. Each stage tracks
/// its progress and due date.
class IssuanceStage extends Equatable {
  final String id;
  final String name;
  final String description;
  final StageStatus status;
  final DateTime dueDate;

  const IssuanceStage({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.dueDate,
  });

  @override
  List<Object?> get props => [id, name, description, status, dueDate];
}

/// Possible statuses for an issuance stage.
enum StageStatus { pending, inProgress, completed, blocked }
