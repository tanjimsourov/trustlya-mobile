import 'package:equatable/equatable.dart';

/// Represents an ownership position in a tokenized asset program. Shows
/// which investor holds how many tokens and their share percentage.
class OwnershipHolder extends Equatable {
  final String investorName;
  final int tokens;
  final double percentage;

  const OwnershipHolder(
      {required this.investorName,
      required this.tokens,
      required this.percentage});

  @override
  List<Object?> get props => [investorName, tokens, percentage];
}
