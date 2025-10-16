import '../models/media_item.dart';

class MockData {
  static List<MediaItem> heroItems = [
    const MediaItem(
      id: 'hero1',
      title: 'FamFlix Originals: The Great Bake-Off',
      posterUrl: 'https://via.placeholder.com/342x513?text=Poster',
      backdropUrl: 'https://via.placeholder.com/1280x720?text=Hero+Backdrop',
      overview: 'A wholesome family bake-off with unexpected plot twists.',
      type: MediaType.show,
      rating: 8.6,
      year: '2024',
      genres: ['Family', 'Reality'],
    ),
  ];

  static List<MediaItem> trending = List.generate(12, (i) {
    return MediaItem(
      id: 't$i',
      title: 'Trending #$i',
      posterUrl: 'https://via.placeholder.com/342x513?text=Trending+$i',
      backdropUrl: 'https://via.placeholder.com/1280x720?text=Backdrop+$i',
      overview: 'Description for trending item $i',
      type: i % 2 == 0 ? MediaType.movie : MediaType.show,
      rating: 7.0 + (i % 3),
      year: '2023',
      genres: const ['Drama'],
    );
  });

  static List<MediaItem> continueWatching = List.generate(9, (i) {
    return MediaItem(
      id: 'cw$i',
      title: 'Continue Watching #$i',
      posterUrl: 'https://via.placeholder.com/342x513?text=CW+$i',
      backdropUrl: 'https://via.placeholder.com/1280x720?text=CW+$i',
      overview: 'Keep watching item $i',
      type: MediaType.show,
      rating: 8.0,
      year: '2022',
      genres: const ['Comedy'],
    );
  });
}
