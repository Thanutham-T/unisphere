import 'package:flutter/material.dart';

class MapSearchBar extends StatelessWidget {
  final Function(String) onSearchChanged;
  final VoidCallback? onProfileTap;

  const MapSearchBar({
    super.key,
    required this.onSearchChanged,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Search Bar
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                      decoration: InputDecoration(
                        hintText: 'ค้นหาในแผนที่',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                        ),
                        filled: false,
                      ),
                      onChanged: onSearchChanged,
                    ),
                  ),
                  Icon(Icons.mic, color: colorScheme.onSurfaceVariant),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Profile Icon
          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: colorScheme.onPrimary, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
