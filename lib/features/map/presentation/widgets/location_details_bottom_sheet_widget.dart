import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/place_entity.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';

class LocationDetailsBottomSheet extends StatelessWidget {
  final PlaceEntity place;

  const LocationDetailsBottomSheet({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      _getCategoryIcon(place.category),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _getCategoryDisplayName(place.category),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<MapBloc>().add(
                          ToggleFavoritePlace(place.id),
                        );
                      },
                      icon: Icon(
                        place.isFavorite ? Icons.favorite : Icons.favorite_border,
                      ),
                    ),
                  ],
                ),
                
                // Description
                if (place.description != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    place.description!,
                  ),
                ],
                
                // Location coordinates (for debugging)
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${place.location.latitude.toStringAsFixed(6)}, ${place.location.longitude.toStringAsFixed(6)}',
                      ),
                    ],
                  ),
                ),
                
                // Action buttons
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<MapBloc>().add(
                            CalculateRoute(
                              destination: place.location,
                              routeType: 'walking',
                            ),
                          );
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.directions_walk),
                        label: const Text('เดิน'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<MapBloc>().add(
                            CalculateRoute(
                              destination: place.location,
                              routeType: 'driving',
                            ),
                          );
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.directions_car),
                        label: const Text('ขับรถ'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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

  String _getCategoryDisplayName(String category) {
    switch (category.toLowerCase()) {
      case 'library':
        return 'ห้องสมุด';
      case 'building':
        return 'อาคาร';
      case 'restaurant':
        return 'ร้านอาหาร';
      case 'sport':
        return 'กีฬา';
      case 'dormitory':
        return 'หอพัก';
      case 'parking':
        return 'ที่จอดรถ';
      case 'medical':
        return 'แพทย์';
      default:
        return 'สถานที่';
    }
  }
}