import 'package:flutter/material.dart';
import '../../models/media_item.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({
    super.key,
    required this.item,
    this.onPlay,
    this.onMoreInfo,
  });

  final MediaItem item;
  final VoidCallback? onPlay;
  final VoidCallback? onMoreInfo;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 6,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            item.backdropUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(color: const Color(0xFF2A2A2A));
            },
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFF2A2A2A),
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image_outlined),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black54, Colors.black87],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (item.overview != null)
                      Text(
                        item.overview!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      children: [
                        ElevatedButton.icon(
                          onPressed: onPlay,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Play'),
                        ),
                        OutlinedButton.icon(
                          onPressed: onMoreInfo,
                          icon: const Icon(Icons.info_outline),
                          label: const Text('More info'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
