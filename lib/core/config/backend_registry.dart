enum BackendFeature {
  auth,
  home,
  activity,
  trading,
  wallet,
  casino,
  carbon,
  profile,
  kyc,
  notifications,
  settings,
  favorites,
  promotions,
  discover,
  suggestions,
  paymentMethods,
  itemTrading,
  tokenization,
  postTrade,
}

enum BackendSource {
  mock,
  api,
  mockFallback,
}

class BackendRegistration {
  const BackendRegistration({
    required this.feature,
    required this.source,
    this.note,
  });

  final BackendFeature feature;
  final BackendSource source;
  final String? note;
}

class BackendRegistry {
  final Map<BackendFeature, BackendRegistration> _registrations = {};

  void register(
    BackendFeature feature, {
    required BackendSource source,
    String? note,
  }) {
    _registrations[feature] = BackendRegistration(
      feature: feature,
      source: source,
      note: note,
    );
  }

  BackendRegistration? operator [](BackendFeature feature) =>
      _registrations[feature];

  List<BackendRegistration> get registrations =>
      _registrations.values.toList(growable: false)
        ..sort((a, b) => a.feature.name.compareTo(b.feature.name));

  int countBySource(BackendSource source) =>
      _registrations.values.where((entry) => entry.source == source).length;

  bool get hasFallbacks => countBySource(BackendSource.mockFallback) > 0;

  String get summaryLabel {
    final apiCount = countBySource(BackendSource.api);
    final fallbackCount = countBySource(BackendSource.mockFallback);
    if (apiCount > 0 && fallbackCount == 0) {
      return '$apiCount live integrations active';
    }
    if (apiCount > 0 && fallbackCount > 0) {
      return '$apiCount live, $fallbackCount fallback';
    }
    if (fallbackCount > 0) {
      return '$fallbackCount mock fallbacks in API mode';
    }
    return '${countBySource(BackendSource.mock)} mock-backed modules';
  }
}
