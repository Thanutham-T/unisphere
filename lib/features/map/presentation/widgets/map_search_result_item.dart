import 'package:flutter/material.dart';
import '../../../../core/logging/app_logger.dart';

class MapSearchResultItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final VoidCallback? onTap;

  const MapSearchResultItem({
    super.key,
    required this.icon,
    required this.name,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 24, color: colorScheme.onPrimary),
        ),
        title: Text(
          name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap:
            onTap ??
            () {
              // TODO: Navigate to selected place on map
              AppLogger.debug('Selected place: $name');
            },
      ),
    );
  }
}
