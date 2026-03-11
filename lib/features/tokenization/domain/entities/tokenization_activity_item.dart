import 'package:equatable/equatable.dart';

/// An activity entry representing a recent action or event related to
/// tokenisation, displayed in the activity feed. Could be an investor
/// onboarding event, issuance update or lifecycle action.
class TokenizationActivityItem extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String type;

  const TokenizationActivityItem({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
  });

  @override
  List<Object?> get props => [id, title, description, date, type];
}
