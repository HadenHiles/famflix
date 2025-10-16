import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'router.dart';

void main() {
  // Web-only: nothing special required, but keep widgets binding initialized.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FamFlixApp());
}

class FamFlixApp extends StatelessWidget {
  const FamFlixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FamFlix',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: createRouter(),
    );
  }
}
