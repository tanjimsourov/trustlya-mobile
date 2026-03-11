import 'carbon_project.dart';

/// Detailed information about a carbon project listed in the marketplace.
class CarbonProjectDetail extends CarbonProject {
  final String story;
  final String verificationInfo;
  final List<double> priceHistory;
  final double availableCredits;

  CarbonProjectDetail({
    required super.id,
    required super.name,
    required super.location,
    required super.badges,
    required super.pricePerCredit,
    required super.category,
    required super.imageUrl,
    required this.story,
    required this.verificationInfo,
    required this.priceHistory,
    required this.availableCredits,
  });

  CarbonProjectDetail copyWith({
    String? id,
    String? name,
    String? location,
    List<String>? badges,
    double? pricePerCredit,
    String? category,
    String? imageUrl,
    String? story,
    String? verificationInfo,
    List<double>? priceHistory,
    double? availableCredits,
  }) {
    return CarbonProjectDetail(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      badges: badges ?? this.badges,
      pricePerCredit: pricePerCredit ?? this.pricePerCredit,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      story: story ?? this.story,
      verificationInfo: verificationInfo ?? this.verificationInfo,
      priceHistory: priceHistory ?? this.priceHistory,
      availableCredits: availableCredits ?? this.availableCredits,
    );
  }
}
