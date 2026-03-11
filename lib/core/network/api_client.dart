import '../config/app_backend.dart';

class ApiClient {
  const ApiClient(this.config);

  final AppBackendConfig config;

  bool get isConfigured => (config.baseUrl ?? '').isNotEmpty;

  Uri buildUri(String path, [Map<String, dynamic>? queryParameters]) {
    final baseUrl = config.baseUrl;
    if (baseUrl == null || baseUrl.isEmpty) {
      throw StateError(
        'TRUSTLYA_API_BASE_URL is not configured for API mode.',
      );
    }

    final baseUri = Uri.parse(baseUrl);
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return baseUri.replace(
      path: '${baseUri.path}$normalizedPath'.replaceAll('//', '/'),
      queryParameters:
          queryParameters?.map((key, value) => MapEntry(key, '$value')),
    );
  }
}
