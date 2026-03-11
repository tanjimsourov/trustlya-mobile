import 'package:equatable/equatable.dart';

/// High level metric representing quantitative insights into an
/// issuance programme such as raise progress or investor diversification.
class IssuanceMetric extends Equatable {
  final String name;
  final String value;
  final double change;

  const IssuanceMetric(
      {required this.name, required this.value, required this.change});

  @override
  List<Object?> get props => [name, value, change];
}
