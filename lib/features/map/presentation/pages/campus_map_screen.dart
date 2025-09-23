import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/place_entity.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';
import '../bloc/map_state.dart';
import '../widgets/map_control_buttons_widget.dart';
import '../widgets/location_details_bottom_sheet_widget.dart';

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});

  @override
  State<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  // Default campus center (adjust to your campus coordinates)
  static const LatLng _campusCenter = LatLng(14.8816, 102.0144);

  @override
  void initState() {
    super.initState();
    // Initialize map data when page loads
    context.read<MapBloc>().add(InitializeMap());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // TODO: Implement search functionality
    // For now, this is a placeholder
    AppLogger.debug('Search query: $query');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (state is MapError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          
          if (state is LocationPermissionDenied) {
            _showLocationPermissionDialog();
          }
          
          if (state is MapLoaded && state.selectedPlace != null) {
            _focusOnPlace(state.selectedPlace!);
            _showPlaceDetails(state.selectedPlace!);
          }
          
          if (state is MapLoaded && state.currentLocation != null) {
            _focusOnCurrentLocation(state.currentLocation!);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Main Map
              _buildMap(state),
              
              // Bottom UI Container
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Card(
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
                      
                      // Search Bar
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Icon(Icons.search),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!.map_search_hint,
                                  border: InputBorder.none,
                                ),
                                onChanged: _onSearchChanged,
                              ),
                            ),
                            const Icon(Icons.mic),
                            const SizedBox(width: 8),
                            const Icon(Icons.person),
                          ],
                        ),
                      ),
                      
                      // Category Label - ไม่แสดง "คลัง" ตามที่คุณบอก
                      // const Text(
                      //   'คลัง',
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.w600,
                      //     color: Colors.black87,
                      //   ),
                      // ),
                      // const SizedBox(height: 12),
                      
                      // Category Icons
                      Container(
                        height: 100,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCategoryIcon(
                              context,
                              Icons.settings,
                              'ตัวเลือกการข...',
                              false,
                            ),
                            _buildCategoryIcon(
                              context,
                              Icons.local_library,
                              'หลังคามงคณ...',
                              false,
                            ),
                            _buildCategoryIcon(
                              context,
                              Icons.local_cafe,
                              'Starbucks',
                              false,
                            ),
                            _buildCategoryIcon(
                              context,
                              Icons.local_post_office,
                              'ไปรษณีย์...',
                              false,
                            ),
                            _buildCategoryIcon(
                              context,
                              Icons.add,
                              'โรงพิมพ์...',
                              false,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              
              // Map Controls (Right side)
              const MapControlButtons(),
              
              // Loading indicator
              if (state is MapLoading)
                Container(
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              
                      // Route calculating indicator
              if (state is RouteCalculating)
                Positioned(
                  bottom: 100,
                  left: 16,
                  right: 16,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 16),
                          Text(AppLocalizations.of(context)!.map_calculating_route),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMap(MapState state) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _campusCenter,
        initialZoom: 16.0,
        minZoom: 14.0,
        maxZoom: 19.0,
        onTap: (tapPosition, point) {
          // Clear selection when tapping empty area
          context.read<MapBloc>().add(ClearSelectedPlace());
        },
      ),
      children: [
        // Tile layer - using OpenStreetMap for offline-like experience
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.unisphere',
          maxZoom: 19,
        ),
        
        // Route polyline
        if (state is MapLoaded && state.currentRoute != null)
          PolylineLayer(
            polylines: [
              Polyline(
                points: _buildRoutePoints(state.currentRoute!),
                strokeWidth: 4.0,
              ),
            ],
          ),
        
        // Place markers
        if (state is MapLoaded)
          MarkerLayer(
            markers: _buildMarkers(state),
          ),
      ],
    );
  }

  List<Marker> _buildMarkers(MapLoaded state) {
    final List<Marker> markers = [];

    // Current location marker
    if (state.currentLocation != null) {
      markers.add(
        Marker(
          point: LatLng(
            state.currentLocation!.latitude,
            state.currentLocation!.longitude,
          ),
          width: 20,
          height: 20,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.my_location,
              size: 12,
            ),
          ),
        ),
      );
    }

    // Place markers
    for (final place in state.filteredPlaces) {
      markers.add(
        Marker(
          point: LatLng(place.location.latitude, place.location.longitude),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              context.read<MapBloc>().add(SelectPlace(place));
            },
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getCategoryIcon(place.category),
                size: 20,
              ),
            ),
          ),
        ),
      );
    }

    return markers;
  }

  List<LatLng> _buildRoutePoints(dynamic route) {
    // Convert route steps to LatLng points
    final List<LatLng> points = [];
    
    // This is a simplified implementation
    // In a real app, you would get the actual route coordinates
    if (route != null) {
      // Add sample route points for demonstration
      points.add(_campusCenter);
      points.add(LatLng(_campusCenter.latitude + 0.001, _campusCenter.longitude + 0.001));
    }
    
    return points;
  }

  void _focusOnPlace(PlaceEntity place) {
    final latLng = LatLng(place.location.latitude, place.location.longitude);
    _mapController.move(latLng, 18.0);
  }

  void _focusOnCurrentLocation(LocationPoint location) {
    final latLng = LatLng(location.latitude, location.longitude);
    _mapController.move(latLng, 17.0);
  }

  void _showPlaceDetails(PlaceEntity place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => LocationDetailsBottomSheet(place: place),
    );
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.map_location_permission_title),
        content: Text(
          AppLocalizations.of(context)!.map_location_permission_message,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<MapBloc>().add(GetCurrentLocation());
            },
            child: Text(AppLocalizations.of(context)!.try_again),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(
    BuildContext context,
    IconData icon,
    String label,
    bool isSelected,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
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
}