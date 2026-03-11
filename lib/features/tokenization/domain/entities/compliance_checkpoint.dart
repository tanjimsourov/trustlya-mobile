import 'package:equatable/equatable.dart';

/// Represents a regulatory or internal compliance check that must be
/// completed before proceeding with an issuance or corporate action.
class ComplianceCheckpoint extends Equatable {
  final String id;
  final String name;
  final String description;
  final ComplianceStatus status;

  const ComplianceCheckpoint({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
  });

  @override
  List<Object?> get props => [id, name, description, status];
}

/// Status for a compliance checkpoint.
enum ComplianceStatus { pending, passed, failed }
