import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Integrations',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          _SettingTile(
            title: 'Jellyseerr Base URL',
            hint: 'http://localhost:5055/api/v1',
          ),
          _SettingTile(
            title: 'Jellyseerr API Key',
            hint: 'paste-your-key',
            isSecret: true,
          ),
          const Divider(height: 32),
          _SettingTile(title: 'Plex Base URL', hint: 'http://localhost:32400'),
          _SettingTile(
            title: 'Plex Token',
            hint: 'X-Plex-Token',
            isSecret: true,
          ),
          _SettingTile(
            title: 'Plex Client Identifier',
            hint: 'famflix-web-client',
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Saved (hook up persistence later).'),
                ),
              );
            },
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
          const SizedBox(height: 12),
          const Text(
            'Note: For web builds you may need to host this app behind the same domain as Jellyseerr/Plex or use a reverse proxy to avoid CORS.',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({required this.title, this.hint, this.isSecret = false});

  final String title;
  final String? hint;
  final bool isSecret;

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
            decoration: InputDecoration(hintText: hint ?? ''),
          ),
        ],
      ),
    );
  }
}
