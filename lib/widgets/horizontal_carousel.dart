import 'package:flutter/material.dart';
import '../models/media_item.dart';
import 'media_poster.dart';

class HorizontalCarousel extends StatelessWidget {
  const HorizontalCarousel({
    super.key,
    required this.title,
    required this.items,
    this.onTapItem,
    this.posterAspectRatio = 342 / 513,
  });

  final String title;
  final List<MediaItem> items;
  final void Function(MediaItem)? onTapItem;
  final double posterAspectRatio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 260,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final item = items[i];
                return SizedBox(
                  width: 150,
                  child: MediaPoster(
                    item: item,
                    aspectRatio: posterAspectRatio,
                    onTap: () => onTapItem?.call(item),
                    caption: Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
