import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/place_entity.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';
import '../bloc/map_state.dart';

class SearchResultsList extends StatelessWidget {
  const SearchResultsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        if (state is! MapLoaded) {
          return const SizedBox.shrink();
        }

        // Only show search results when actively searching or filtering
        if (state.searchQuery.isEmpty && state.selectedCategory == null) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxHeight: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: state.filteredPlaces.isEmpty
              ? _buildEmptyState(state)
              : _buildResultsList(context, state.filteredPlaces),
        );
      },
    );
  }

  Widget _buildEmptyState(MapLoaded state) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            state.searchQuery.isNotEmpty
                ? 'ไม่พบสถานที่ที่ค้นหา'
                : 'ไม่พบสถานที่ในหมวดหมู่นี้',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            state.searchQuery.isNotEmpty
                ? 'ลองค้นหาด้วยคำอื่น'
                : 'ลองเปลี่ยนหมวดหมู่',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList(BuildContext context, List<PlaceEntity> places) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: places.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: Colors.grey[200],
      ),
      itemBuilder: (context, index) {
        final place = places[index];
        return ListTile(
          onTap: () {
            // Select place and focus on map
            context.read<MapBloc>().add(SelectPlace(place));
          },
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getCategoryColor(place.category).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getCategoryIcon(place.category),
              color: _getCategoryColor(place.category),
              size: 20,
            ),
          ),
          title: Text(
            place.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: place.description != null
              ? Text(
                  place.description!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (place.isFavorite)
                Icon(
                  Icons.favorite,
                  size: 16,
                  color: Colors.red[400],
                ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'library':
        return Icons.local_library;
      case 'building':
        return Icons.business;
      case 'restaurant':
        return Icons.restaurant;
      case 'sport':
        return Icons.sports_soccer;
      case 'dormitory':
        return Icons.hotel;
      case 'parking':
        return Icons.local_parking;
      case 'medical':
        return Icons.local_hospital;
      default:
        return Icons.place;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'library':
        return Colors.purple;
      case 'building':
        return Colors.blue;
      case 'restaurant':
        return Colors.orange;
      case 'sport':
        return Colors.green;
      case 'dormitory':
        return Colors.indigo;
      case 'parking':
        return Colors.grey;
      case 'medical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}