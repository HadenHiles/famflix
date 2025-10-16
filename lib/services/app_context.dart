import 'dart:async';
import 'package:flutter/widgets.dart';
import 'settings_store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'jellyseerr_service.dart';
import 'plex_service.dart';

class AppContext {
  AppContext._(this.settings, this.version);
  final SettingsStore settings;
  final ValueNotifier<int> version;

  JellyseerrService? _jelly;
  PlexService? _plex;

  Future<void> initialize() async {
    // preload to avoid jank if needed
    await SharedPreferences.getInstance();
  }

  void onSettingsChanged(Map<String, String> data) {
    _jelly = null;
    _plex = null;
    version.value++;
  }

  Future<JellyseerrService?> jelly() async {
    final map = await settings.load();
    final base = map[SettingsStore.jellyBaseKey];
    final key = map[SettingsStore.jellyApiKey];
    if (base == null || base.isEmpty || key == null || key.isEmpty) return null;
    _jelly ??= JellyseerrService(baseUrl: base, apiKey: key);
    return _jelly;
  }

  Future<PlexService?> plex() async {
    final map = await settings.load();
    final base = map[SettingsStore.plexBaseKey];
    final token = map[SettingsStore.plexTokenKey];
    final client = map[SettingsStore.plexClientIdKey] ?? 'famflix-web';
    if (base == null || base.isEmpty || token == null || token.isEmpty) return null;
    _plex ??= PlexService(baseUrl: base, token: token, machineIdentifier: client);
    return _plex;
  }

  static AppContext create() {
    return AppContext._(SettingsStore.instance, ValueNotifier<int>(0));
  }
}

class AppCtx extends InheritedWidget {
  const AppCtx({super.key, required this.ctx, required super.child});

  final AppContext ctx;

  static AppContext of(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<AppCtx>();
    assert(inherited != null, 'AppCtx not found in widget tree');
    return inherited!.ctx;
  }

  @override
  bool updateShouldNotify(covariant AppCtx oldWidget) => oldWidget.ctx != ctx;
}
