/// Represents analytics about the user’s environmental impact from
/// carbon offset activities. Provides total offset and data series
/// for monthly and yearly views, as well as a breakdown of offset
/// contributions by project.
class ImpactAnalytics {
  final double totalOffset;
  final List<double> monthlyData; // length 12 representing last 12 months
  final List<double> yearlyData; // length N representing last N years
  final Map<String, double> projectBreakdown; // projectName → offset amount

  ImpactAnalytics({
    required this.totalOffset,
    required this.monthlyData,
    required this.yearlyData,
    required this.projectBreakdown,
  });
}
