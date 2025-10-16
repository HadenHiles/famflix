import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsStore {
  SettingsStore._();
  static final SettingsStore instance = SettingsStore._();

  static const jellyBaseKey = 'jelly_base_url';
  static const jellyApiKey = 'jelly_api_key';
  static const plexBaseKey = 'plex_base_url';
  static const plexTokenKey = 'plex_token';
  static const plexClientIdKey = 'plex_client_id';
  static const plexSectionKey = 'plex_section_key';

  final _controller = StreamController<Map<String, String>>.broadcast();
  Stream<Map<String, String>> watch() => _controller.stream;

  Future<void> save({required Map<String, String> values}) async {
    final prefs = await SharedPreferences.getInstance();
    for (final entry in values.entries) {
      await prefs.setString(entry.key, entry.value);
    }
    _controller.add(await load());
  }

  Future<Map<String, String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final map = <String, String>{};
    void put(String k) {
      final v = prefs.getString(k);
      if (v != null) map[k] = v;
    }

    for (final k in [jellyBaseKey, jellyApiKey, plexBaseKey, plexTokenKey, plexClientIdKey, plexSectionKey]) {
      put(k);
    }
    return map;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    for (final k in [jellyBaseKey, jellyApiKey, plexBaseKey, plexTokenKey, plexClientIdKey, plexSectionKey]) {
      await prefs.remove(k);
    }
    _controller.add(await load());
  }

  void dispose() {
    _controller.close();
  }
}
