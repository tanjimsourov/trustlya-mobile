import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/config/app_backend.dart';
import 'app/dependency_injection.dart' as di;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  di.init(backendConfig: AppBackendConfig.fromEnvironment());
  runApp(const TrustlyaApp());
}
