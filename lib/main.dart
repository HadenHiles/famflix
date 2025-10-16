import 'package:flutter/material.dart';
import 'dart:async';
import 'app_theme.dart';
import 'router.dart';
import 'services/app_context.dart';
import 'services/settings_store.dart';

void main() {
  // Web-only: nothing special required, but keep widgets binding initialized.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FamFlixApp());
}

class FamFlixApp extends StatefulWidget {
  const FamFlixApp({super.key});

  @override
  State<FamFlixApp> createState() => _FamFlixAppState();
}

class _FamFlixAppState extends State<FamFlixApp> {
  late final AppContext _ctx = AppContext.create();
  StreamSubscription<Map<String, String>>? _sub;

  @override
  void initState() {
    super.initState();
    _ctx.initialize();
    _sub = SettingsStore.instance.watch().listen(_ctx.onSettingsChanged);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppCtx(
      ctx: _ctx,
      child: ValueListenableBuilder<int>(
        valueListenable: _ctx.version,
        builder: (context, _, __) {
          return MaterialApp.router(title: 'FamFlix', debugShowCheckedModeBanner: false, theme: AppTheme.darkTheme, routerConfig: createRouter());
        },
      ),
    );
  }
}
