import 'carbon_project.dart';

/// Data model for the carbon marketplace dashboard. Contains aggregate
/// information about the user’s holdings and environmental impact as
/// well as featured projects and current market prices.
class MarketplaceDashboardData {
  final double totalCreditsHeld;
  final double totalImpact; // total CO₂ offset in tonnes
  final List<CarbonProject> featuredProjects;
  final Map<String, double> latestPrices; // projectId → price per credit

  MarketplaceDashboardData({
    required this.totalCreditsHeld,
    required this.totalImpact,
    required this.featuredProjects,
    required this.latestPrices,
  });
}
