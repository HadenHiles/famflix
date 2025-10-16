import 'package:flutter/material.dart';
import '../models/media_item.dart';
import '../widgets/media_poster.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.item});

  final MediaItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 200, child: MediaPoster(item: item)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: [
                        if (item.year != null) Chip(label: Text(item.year!)),
                        Chip(
                          label: Text(
                            item.type == MediaType.movie ? 'Movie' : 'Series',
                          ),
                        ),
                        Chip(
                          label: Text('★ ${item.rating.toStringAsFixed(1)}'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (item.overview != null)
                      Text(
                        item.overview!,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Play on Plex'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add),
                          label: const Text('Request via Jellyseerr'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
