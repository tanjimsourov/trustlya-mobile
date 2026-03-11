/// Represents a third‑party account linked to the user's Trustlya account.
/// Each linked account stores the provider name (e.g. Google, Steam)
/// and the username or identifier used on that provider. These are
/// displayed in the profile overview to summarise external connections.
class LinkedAccount {
  final String provider;
  final String username;

  LinkedAccount({required this.provider, required this.username});
}
