// Minimal Plex API reader (library + posters).
// For web: you may need a reverse proxy due to CORS and token privacy.
// This client is intentionally simple: it fetches items from a given library
// section and maps them to MediaItem with poster URLs.
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/media_item.dart';

class PlexService {
  PlexService({
    required this.baseUrl,
    required this.token,
    required this.machineIdentifier,
  });

  final String baseUrl; // e.g., http://your-plex:32400
  final String token; // X-Plex-Token
  final String
  machineIdentifier; // X-Plex-Client-Identifier (string you choose)

  Map<String, String> get _headers => {
    'X-Plex-Token': token,
    'X-Plex-Client-Identifier': machineIdentifier,
    'Accept': 'application/json',
  };

  /// Example: get recently added for a library section (key)
  /// Find section keys via /library/sections
  Future<List<MediaItem>> fetchRecentlyAdded(String sectionKey) async {
    final uri = Uri.parse(
      '$baseUrl/library/sections/$sectionKey/recentlyAdded?X-Plex-Token=$token',
    );
    final res = await http.get(uri, headers: _headers);
    if (res.statusCode != 200) {
      throw Exception(
        'Plex recentlyAdded failed: ${res.statusCode} ${res.reasonPhrase}',
      );
    }
    final data = json.decode(res.body);
    final media = <MediaItem>[];
    final metadata =
        (((data['MediaContainer'] ?? {})['Metadata']) as List?) ?? [];
    for (final raw in metadata) {
      final type = (raw['type'] == 'show' || raw['type'] == 'episode')
          ? MediaType.show
          : MediaType.movie;
      final rating = (raw['rating'] is num)
          ? (raw['rating'] as num).toDouble()
          : 0.0;
      final year = raw['year']?.toString();
      final String thumb = raw['thumb'] ?? '';
      final String art = raw['art'] ?? '';
      String posterUrl = thumb.isNotEmpty
          ? '$baseUrl$thumb?X-Plex-Token=$token'
          : 'https://via.placeholder.com/342x513?text=Poster';
      String backdropUrl = art.isNotEmpty
          ? '$baseUrl$art?X-Plex-Token=$token'
          : 'https://via.placeholder.com/1280x720?text=Backdrop';
      media.add(
        MediaItem(
          id: (raw['ratingKey'] ?? '').toString(),
          title: raw['title'] ?? '',
          overview: raw['summary'],
          posterUrl: posterUrl,
          backdropUrl: backdropUrl,
          type: type,
          rating: rating,
          year: year,
          genres: const [],
        ),
      );
    }
    return media;
  }
}
