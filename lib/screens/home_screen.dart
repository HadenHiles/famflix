import 'package:flutter/material.dart';
import '../services/mock_data.dart';
import '../widgets/horizontal_carousel.dart';
import '../models/media_item.dart';
import 'components/top_nav_bar.dart';
import 'components/hero_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // In the future, flip these flags to use Jellyseerr/Plex services
  // and wire actual data flows.
  final bool _useMock = true;

  void _onTapItem(MediaItem item) {
    // Use Navigator.of(context).push if you migrate away from Router.
    // For now, a simple bottom sheet to keep things "dumbed down".
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1F1F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              if (item.overview != null)
                Text(
                  item.overview!,
                  style: const TextStyle(color: Colors.white70),
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play (Plex)'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.add),
                    label: const Text('Request (Jellyseerr)'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hero = MockData.heroItems.first;
    return Scaffold(
      appBar: TopNavBar(
        onHome: () {},
        onSearch: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const _SearchShortcut())),
        onProfile: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const _ProfileShortcut())),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HeroBanner(item: hero, onPlay: () {}, onMoreInfo: () {}),
          ),
          SliverToBoxAdapter(
            child: HorizontalCarousel(
              title: 'Trending Now',
              items: _useMock ? MockData.trending : const <MediaItem>[],
              onTapItem: _onTapItem,
            ),
          ),
          SliverToBoxAdapter(
            child: HorizontalCarousel(
              title: 'Continue Watching',
              items: _useMock ? MockData.continueWatching : const <MediaItem>[],
              onTapItem: _onTapItem,
            ),
          ),
        ],
      ),
    );
  }
}

// Lightweight shortcuts to demo navigation without depending on Router impl.
class _SearchShortcut extends StatelessWidget {
  const _SearchShortcut();

  @override
  Widget build(BuildContext context) => const Placeholder();
}

class _ProfileShortcut extends StatelessWidget {
  const _ProfileShortcut();

  @override
  Widget build(BuildContext context) => const Placeholder();
}
