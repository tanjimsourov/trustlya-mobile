import 'package:equatable/equatable.dart';

/// Represents a tokenized asset program offered to investors. Each program
/// contains metadata about the underlying asset, total supply and status.
class TokenizedAssetProgram extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime issuanceDate;
  final int totalTokens;
  final int allocatedTokens;
  final ProgramStatus status;

  const TokenizedAssetProgram({
    required this.id,
    required this.name,
    required this.description,
    required this.issuanceDate,
    required this.totalTokens,
    required this.allocatedTokens,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        issuanceDate,
        totalTokens,
        allocatedTokens,
        status
      ];
}

/// Possible lifecycle statuses for a tokenized asset program.
enum ProgramStatus { planning, active, completed, paused }
