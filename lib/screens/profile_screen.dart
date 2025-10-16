import 'package:flutter/material.dart';
import '../services/settings_store.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _jellyBase = TextEditingController();
  final _jellyKey = TextEditingController();
  final _plexBase = TextEditingController();
  final _plexToken = TextEditingController();
  final _plexClient = TextEditingController(text: 'famflix-web');
  final _plexSection = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final map = await SettingsStore.instance.load();
    if (!mounted) return;
    setState(() {
      _jellyBase.text = map[SettingsStore.jellyBaseKey] ?? '';
      _jellyKey.text = map[SettingsStore.jellyApiKey] ?? '';
      _plexBase.text = map[SettingsStore.plexBaseKey] ?? '';
      _plexToken.text = map[SettingsStore.plexTokenKey] ?? '';
      _plexClient.text = map[SettingsStore.plexClientIdKey] ?? _plexClient.text;
      _plexSection.text = map[SettingsStore.plexSectionKey] ?? '';
    });
  }

  @override
  void dispose() {
    _jellyBase.dispose();
    _jellyKey.dispose();
    _plexBase.dispose();
    _plexToken.dispose();
    _plexClient.dispose();
    _plexSection.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final values = <String, String>{
      SettingsStore.jellyBaseKey: _jellyBase.text.trim(),
      SettingsStore.jellyApiKey: _jellyKey.text.trim(),
      SettingsStore.plexBaseKey: _plexBase.text.trim(),
      SettingsStore.plexTokenKey: _plexToken.text.trim(),
      SettingsStore.plexClientIdKey: _plexClient.text.trim(),
      SettingsStore.plexSectionKey: _plexSection.text.trim(),
    };
    await SettingsStore.instance.save(values: values);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved settings')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Integrations', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          _SettingTile(title: 'Jellyseerr Base URL', hint: 'http://localhost:5055/api/v1', controller: _jellyBase),
          _SettingTile(title: 'Jellyseerr API Key', hint: 'paste-your-key', isSecret: true, controller: _jellyKey),
          const Divider(height: 32),
          _SettingTile(title: 'Plex Base URL', hint: 'http://localhost:32400', controller: _plexBase),
          _SettingTile(title: 'Plex Token', hint: 'X-Plex-Token', isSecret: true, controller: _plexToken),
          _SettingTile(title: 'Plex Client Identifier', hint: 'famflix-web', controller: _plexClient),
          _SettingTile(title: 'Plex Section Key', hint: '1', controller: _plexSection),
          const SizedBox(height: 24),
          FilledButton.icon(onPressed: _save, icon: const Icon(Icons.save), label: const Text('Save')),
          const SizedBox(height: 12),
          const Text('Note: For web builds you may need to host this app behind the same domain as Jellyseerr/Plex or use a reverse proxy to avoid CORS.', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({required this.title, this.hint, this.isSecret = false, required this.controller});

  final String title;
  final String? hint;
  final bool isSecret;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          TextField(
            obscureText: isSecret,
            controller: controller,
            decoration: InputDecoration(hintText: hint ?? ''),
          ),
        ],
      ),
    );
  }
}
