import 'package:flutter/material.dart';
import '../models/media_item.dart';

class MediaPoster extends StatelessWidget {
  const MediaPoster({
    super.key,
    required this.item,
    this.onTap,
    this.aspectRatio = 342 / 513,
    this.caption,
  });

  final MediaItem item;
  final VoidCallback? onTap;
  final double aspectRatio;
  final Widget? caption;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: aspectRatio,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.posterUrl,
                fit: BoxFit.cover,
                frameBuilder: (context, child, frame, wasSync) {
                  if (frame == null) {
                    return Container(color: const Color(0xFF2A2A2A));
                  }
                  return child;
                },
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF2A2A2A),
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image_outlined),
                ),
              ),
            ),
          ),
          if (caption != null)
            Padding(padding: const EdgeInsets.only(top: 8.0), child: caption!),
        ],
      ),
    );
  }
}
