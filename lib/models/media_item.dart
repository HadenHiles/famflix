import 'package:flutter/foundation.dart';

enum MediaType { movie, show }

@immutable
class MediaItem {
  final String id;
  final String title;
  final String? overview;
  final String posterUrl;
  final String backdropUrl;
  final MediaType type;
  final double rating;
  final String? year;
  final List<String> genres;

  const MediaItem({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.backdropUrl,
    required this.type,
    this.overview,
    this.rating = 0.0,
    this.year,
    this.genres = const [],
  });

  MediaItem copyWith({
    String? id,
    String? title,
    String? overview,
    String? posterUrl,
    String? backdropUrl,
    MediaType? type,
    double? rating,
    String? year,
    List<String>? genres,
  }) {
    return MediaItem(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterUrl: posterUrl ?? this.posterUrl,
      backdropUrl: backdropUrl ?? this.backdropUrl,
      type: type ?? this.type,
      rating: rating ?? this.rating,
      year: year ?? this.year,
      genres: genres ?? this.genres,
    );
  }
}
