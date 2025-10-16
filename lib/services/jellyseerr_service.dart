// Minimal Jellyseerr API client (stub-friendly).
// Note: For web builds you may need to handle CORS via reverse proxy or
// by hosting this app on the same origin as Jellyseerr.
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../env/env.dart';
import '../models/media_item.dart';

class JellyseerrService {
  JellyseerrService({String? baseUrl, String? apiKey}) : baseUrl = baseUrl ?? Env.jellyseerrBaseUrl, apiKey = apiKey ?? Env.jellyseerrApiKey;

  final String baseUrl; // e.g., http://your-jellyseerr:5055/api/v1
  final String apiKey;

  Map<String, String> get _headers => {'X-Api-Key': apiKey, 'Content-Type': 'application/json'};

  /// Example: fetch "trending" (maps cleanly to MediaItem)
  Future<List<MediaItem>> fetchTrending({int page = 1}) async {
    final uri = Uri.parse('$baseUrl/discover/trending?page=$page');
    final res = await http.get(uri, headers: _headers);
    if (res.statusCode != 200) {
      throw Exception('Jellyseerr trending failed: ${res.statusCode} ${res.body}');
    }
    final data = json.decode(res.body);
    final results = (data['results'] as List? ?? []);
    return results.map<MediaItem>((raw) => _mapDiscoverToMediaItem(raw)).toList();
  }

  /// Search movies/shows
  Future<List<MediaItem>> search(String query) async {
    if (query.isEmpty) return [];
    final uri = Uri.parse('$baseUrl/search?query=${Uri.encodeQueryComponent(query)}');
    final res = await http.get(uri, headers: _headers);
    if (res.statusCode != 200) {
      throw Exception('Jellyseerr search failed: ${res.statusCode} ${res.body}');
    }
    final data = json.decode(res.body);
    final results = (data['results'] as List? ?? []);
    return results.map<MediaItem>((raw) => _mapSearchToMediaItem(raw)).toList();
  }

  MediaItem _mapDiscoverToMediaItem(Map<String, dynamic> raw) {
    // Jellyseerr proxy returns TMDB-like fields
    final type = (raw['mediaType'] == 'tv') ? MediaType.show : MediaType.movie;
    final poster = raw['posterPath'] ?? '';
    final backdrop = raw['backdropPath'] ?? '';
    final title = type == MediaType.movie ? (raw['title'] ?? '') : (raw['name'] ?? '');
    final year = (raw['releaseDate'] ?? raw['firstAirDate'] ?? '').toString().split('-').first;
    final rating = (raw['voteAverage'] is num) ? (raw['voteAverage'] as num).toDouble() : 0.0;

    return MediaItem(
      id: (raw['id'] ?? '').toString(),
      title: title,
      posterUrl: _tmdbImage(poster, size: 'w342'),
      backdropUrl: _tmdbImage(backdrop, size: 'w780'),
      type: type,
      overview: raw['overview'],
      rating: rating,
      year: year.isEmpty ? null : year,
      genres: const [], // genre mapping omitted for simplicity
    );
  }

  MediaItem _mapSearchToMediaItem(Map<String, dynamic> raw) {
    // Similar to discover
    return _mapDiscoverToMediaItem(raw);
  }

  String _tmdbImage(String path, {String size = 'w342'}) {
    if (path.isEmpty) return 'https://via.placeholder.com/342x513?text=Poster';
    return 'https://image.tmdb.org/t/p/$size$path';
  }
}
