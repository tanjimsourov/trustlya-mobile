enum AppBackendMode {
  mock,
  api,
}

class AppBackendConfig {
  const AppBackendConfig({
    required this.mode,
    this.baseUrl,
    this.allowMockFallback = true,
  });

  factory AppBackendConfig.fromEnvironment() {
    final modeValue = String.fromEnvironment(
      'TRUSTLYA_BACKEND_MODE',
      defaultValue: 'mock',
    );
    final baseUrl = String.fromEnvironment(
      'TRUSTLYA_API_BASE_URL',
      defaultValue: '',
    ).trim();
    final allowMockFallback = String.fromEnvironment(
          'TRUSTLYA_ALLOW_MOCK_FALLBACK',
          defaultValue: 'true',
        ).trim().toLowerCase() !=
        'false';

    return AppBackendConfig(
      mode: AppBackendModeX.parse(modeValue),
      baseUrl: baseUrl.isEmpty ? null : baseUrl,
      allowMockFallback: allowMockFallback,
    );
  }

  final AppBackendMode mode;
  final String? baseUrl;
  final bool allowMockFallback;

  bool get usesApi => mode == AppBackendMode.api;
  bool get usesMockData => mode == AppBackendMode.mock;
  bool get hasBaseUrl => (baseUrl ?? '').isNotEmpty;

  String get statusLabel => usesApi ? 'API-first workspace' : 'Mock workspace';

  String get detailLabel {
    if (usesApi && hasBaseUrl) {
      return 'Base URL configured';
    }
    if (usesApi) {
      return 'Awaiting live endpoint';
    }
    return 'Using seeded data sources';
  }
}

extension AppBackendModeX on AppBackendMode {
  static AppBackendMode parse(String value) {
    switch (value.trim().toLowerCase()) {
      case 'api':
      case 'live':
      case 'remote':
        return AppBackendMode.api;
      default:
        return AppBackendMode.mock;
    }
  }

  String get value {
    switch (this) {
      case AppBackendMode.mock:
        return 'mock';
      case AppBackendMode.api:
        return 'api';
    }
  }
}
