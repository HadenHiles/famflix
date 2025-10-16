import 'package:flutter/material.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  const TopNavBar({super.key, this.onSearch, this.onProfile, this.onHome});

  final VoidCallback? onSearch;
  final VoidCallback? onProfile;
  final VoidCallback? onHome;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 8,
      title: GestureDetector(
        onTap: onHome,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.play_circle_fill, color: Colors.redAccent, size: 28),
            SizedBox(width: 8),
            Text('FamFlix', style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Search',
          icon: const Icon(Icons.search),
          onPressed: onSearch,
        ),
        IconButton(
          tooltip: 'Profile',
          icon: const Icon(Icons.person_outline),
          onPressed: onProfile,
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
