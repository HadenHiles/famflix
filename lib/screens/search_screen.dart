import 'package:flutter/material.dart';
import '../models/media_item.dart';
import '../widgets/horizontal_carousel.dart';
import '../widgets/media_poster.dart';
import '../services/mock_data.dart';
import '../services/app_context.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  List<MediaItem> _results = [];
  bool _searching = false;
  String? _error;

  Future<void> _doSearch(String query) async {
    if (query.trim().isEmpty) return;
    setState(() {
      _searching = true;
      _error = null;
    });
    try {
      final jelly = await AppCtx.of(context).jelly();
      if (jelly == null) {
        await Future.delayed(const Duration(milliseconds: 150));
        _results = MockData.trending.where((e) => e.title.toLowerCase().contains(query.toLowerCase())).toList();
      } else {
        _results = await jelly.search(query);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      if (!mounted) return;
      setState(() => _searching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Search movies, shows...',
              suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: () => _doSearch(_controller.text)),
            ),
            onSubmitted: _doSearch,
          ),
          const SizedBox(height: 16),
          if (_searching) const LinearProgressIndicator(),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(_error!, style: const TextStyle(color: Colors.redAccent)),
            ),
          if (_results.isEmpty && !_searching) const Padding(padding: EdgeInsets.only(top: 24.0), child: Text('Try searching for something you love ✨')),
          if (_results.isNotEmpty)
            HorizontalCarousel(
              title: 'Results',
              items: _results,
              onTapItem: (item) {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text(item.title),
                      content: SizedBox(width: 200, child: MediaPoster(item: item)),
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
