import 'package:flutter/material.dart';
import 'map_search_bar.dart';
import 'map_category_icon.dart';
import 'map_search_result_item.dart';

class MapBottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  final String searchQuery;
  final List<Map<String, dynamic>> filteredPlaces;
  final List<Map<String, dynamic>> categoryPlaces;
  final Function(String) onSearchChanged;
  final bool showFullContent;

  const MapBottomSheet({
    super.key,
    required this.scrollController,
    required this.searchQuery,
    required this.filteredPlaces,
    required this.categoryPlaces,
    required this.onSearchChanged,
    required this.showFullContent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasSearchResults = searchQuery.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Search Bar and Profile Icon Row
            MapSearchBar(onSearchChanged: onSearchChanged),

            // Show search results or category icons
            if (hasSearchResults) ...[
              _buildSearchResults(context),
            ] else if (showFullContent) ...[
              _buildCategorySection(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    final theme = Theme.of(context);

    if (filteredPlaces.isNotEmpty) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ผลการค้นหา',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...filteredPlaces
              .map(
                (place) => MapSearchResultItem(
                  icon: place['icon'],
                  name: place['name'],
                ),
              )
              .toList(),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          'ไม่พบสถานที่ที่ค้นหา',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
        ),
      );
    }
  }

  Widget _buildCategorySection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Category Label
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'คลัง',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Category Icons
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
          ),
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categoryPlaces.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final place = categoryPlaces[index];
              return MapCategoryIcon(
                icon: place['icon'],
                label: place['name'],
                isSelected: false,
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
