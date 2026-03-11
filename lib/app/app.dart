import 'package:flutter/material.dart';
import '../core/constants/strings.dart';
import 'routes.dart';
import 'theme.dart';

/// Root widget for Trustlya.
class TrustlyaApp extends StatelessWidget {
  const TrustlyaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      debugShowCheckedModeBanner: false,
      theme: TrustlyaTheme.lightTheme,
      darkTheme: TrustlyaTheme.darkTheme,
      initialRoute: Routes.initial,
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
