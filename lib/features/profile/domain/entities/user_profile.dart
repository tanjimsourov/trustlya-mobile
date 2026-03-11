/// Represents the user's profile data.
import 'linked_account.dart';

/// Represents the user's profile data. In addition to basic contact
/// information this model also holds account tier, verification status,
/// join date, completion percentage and a list of linked third‑party
/// accounts. The additional fields enable a richer profile overview UI.
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final String tier;
  final bool verified;
  final DateTime joinedDate;
  final double completion;
  final List<LinkedAccount> linkedAccounts;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.tier,
    required this.verified,
    required this.joinedDate,
    required this.completion,
    required this.linkedAccounts,
  });

  /// Creates a copy of this profile with modified fields. This makes
  /// updating the profile in the cubit easier without losing other
  /// properties.
  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? tier,
    bool? verified,
    DateTime? joinedDate,
    double? completion,
    List<LinkedAccount>? linkedAccounts,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      tier: tier ?? this.tier,
      verified: verified ?? this.verified,
      joinedDate: joinedDate ?? this.joinedDate,
      completion: completion ?? this.completion,
      linkedAccounts: linkedAccounts ?? this.linkedAccounts,
    );
  }
}
