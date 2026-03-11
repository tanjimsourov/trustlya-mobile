import 'package:equatable/equatable.dart';

/// Aggregated overview data for the tokenization hub. Includes high
/// level counts and summary statistics to display on the landing page.
class TokenizationOverviewData extends Equatable {
  final int totalPrograms;
  final int activePrograms;
  final int investors;
  final int pendingOnboardings;

  const TokenizationOverviewData({
    required this.totalPrograms,
    required this.activePrograms,
    required this.investors,
    required this.pendingOnboardings,
  });

  @override
  List<Object?> get props =>
      [totalPrograms, activePrograms, investors, pendingOnboardings];
}
