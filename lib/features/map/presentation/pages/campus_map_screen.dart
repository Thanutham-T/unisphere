import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/place_entity.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';
import '../bloc/map_state.dart';
import '../widgets/location_details_bottom_sheet_widget.dart';

class CampusMapScreen extends StatelessWidget {
  const CampusMapScreen({super.key});

  // Static controllers for stateless implementation
  static final MapController _mapController = MapController();
  static final ValueNotifier<String> _searchQuery = ValueNotifier('');
  
  // Default campus center (adjust to your campus coordinates)
  static const LatLng _campusCenter = LatLng(14.8816, 102.0144);

  // Mock data for places in warehouse/storage with icons
  static const List<Map<String, dynamic>> _warehousePlaces = [
    {'name': 'คณะวิศวกรรมศาสตร์', 'icon': Icons.school},
    {'name': 'หอสมุดคุณหญิงหลง', 'icon': Icons.local_library},
    {'name': 'Starbucks', 'icon': Icons.local_cafe},
    {'name': 'ตลาดเกษตร มอ', 'icon': Icons.store},
    {'name': 'โรงพยาบาล มอ', 'icon': Icons.local_hospital},
    {'name': 'โรงอาหาร', 'icon': Icons.restaurant},
  ];

  void _onSearchChanged(String query, BuildContext context) {
    _searchQuery.value = query;
    AppLogger.debug('Search query: $query');
  }

  List<Map<String, dynamic>> _getFilteredPlaces(String query) {
    if (query.isEmpty) return [];
    
    return _warehousePlaces
        .where((place) => place['name'].toString().toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize map when widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapBloc>().add(InitializeMap());
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('แผนที่'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // Cache status indicator
          Tooltip(
            message: 'แผนที่รองรับการใช้งานออฟไลน์',
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.offline_bolt,
                color: Colors.green[600],
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (state is MapError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          
          if (state is LocationPermissionDenied) {
            _showLocationPermissionDialog(context);
          }
          
          if (state is MapLoaded && state.selectedPlace != null) {
            _focusOnPlace(state.selectedPlace!);
            _showPlaceDetails(state.selectedPlace!, context);
          }
          
          if (state is MapLoaded && state.currentLocation != null) {
            _focusOnCurrentLocation(state.currentLocation!);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Main Map
              _buildMap(state, context),
              
              // Draggable Bottom Sheet
              DraggableScrollableSheet(
                initialChildSize: 0.35,
                minChildSize: 0.15,
                maxChildSize: 0.35,
                snap: true,
                snapSizes: const [0.15, 0.35],
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Calculate if we should show full content based on container height
                        final screenHeight = MediaQuery.of(context).size.height;
                        final currentHeight = constraints.maxHeight;
                        final sizeRatio = currentHeight / screenHeight;
                        final showFullContent = sizeRatio > 0.25;
                        
                        return SingleChildScrollView(
                          controller: scrollController,
                          child: ValueListenableBuilder<String>(
                            valueListenable: _searchQuery,
                            builder: (context, searchQuery, child) {
                              final filteredPlaces = _getFilteredPlaces(searchQuery);
                              final hasSearchResults = searchQuery.isNotEmpty;
                              
                              return Column(
                                children: [
                                  // Handle bar
                                  Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    width: 40,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  
                                  // Search Bar and Profile Icon Row
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        // Search Bar
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius: BorderRadius.circular(24),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.search, color: Colors.grey),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: TextField(
                                                    decoration: const InputDecoration(
                                                      hintText: 'ค้นหาในแผนที่',
                                                      border: InputBorder.none,
                                                      hintStyle: TextStyle(color: Colors.grey),
                                                    ),
                                                    onChanged: (query) => _onSearchChanged(query, context),
                                                  ),
                                                ),
                                                const Icon(Icons.mic, color: Colors.grey),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // Profile Icon
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Show search results or category icons
                                  if (hasSearchResults) ...[
                                    // Search Results
                                    if (filteredPlaces.isNotEmpty) ...[
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'ผลการค้นหา',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ...filteredPlaces.map((place) => _buildSearchResultItem(
                                        context,
                                        place['icon'],
                                        place['name'],
                                      )).toList(),
                                    ] else ...[
                                      const Padding(
                                        padding: EdgeInsets.all(32),
                                        child: Text(
                                          'ไม่พบสถานที่ที่ค้นหา',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ] else if (showFullContent) ...[
                                    // Category Label and Icons - Only show when expanded and no search
                                    // Category Label
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'คลัง',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
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
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      height: 120, // Fixed height for horizontal scroll
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          _buildCategoryIcon(
                                            context,
                                            Icons.school,
                                            'คณะวิศวกรรมศาสตร์',
                                            false,
                                          ),
                                          const SizedBox(width: 16),
                                          _buildCategoryIcon(
                                            context,
                                            Icons.local_library,
                                            'หอสมุดคุณหญิงหลง',
                                            false,
                                          ),
                                          const SizedBox(width: 16),
                                          _buildCategoryIcon(
                                            context,
                                            Icons.local_cafe,
                                            'Starbucks',
                                            false,
                                          ),
                                          const SizedBox(width: 16),
                                          _buildCategoryIcon(
                                            context,
                                            Icons.store,
                                            'ตลาดเกษตร มอ',
                                            false,
                                          ),
                                          const SizedBox(width: 16),
                                          _buildCategoryIcon(
                                            context,
                                            Icons.local_hospital,
                                            'โรงพยาบาล มอ',
                                            false,
                                          ),
                                          const SizedBox(width: 16),
                                          _buildCategoryIcon(
                                            context,
                                            Icons.restaurant,
                                            'โรงอาหาร',
                                            false,
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 20),
                                  ],
                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              
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
                          Text('กำลังคำนวณเส้นทาง...'),
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

  Widget _buildMap(MapState state, BuildContext context) {
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
        // Cached Tile layer - automatically caches tiles for offline use
        // Uses CachedNetworkImage to store tiles locally on device
        // When offline, displays cached tiles if available
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.unisphere',
          maxZoom: 19,
          tileBuilder: (context, widget, tile) {
            // Generate URL from tile coordinates
            final url = 'https://tile.openstreetmap.org/${tile.coordinates.z}/${tile.coordinates.x}/${tile.coordinates.y}.png';
            
            return CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.fill,
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
              memCacheWidth: 256,
              memCacheHeight: 256,
              maxWidthDiskCache: 256,
              maxHeightDiskCache: 256,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                width: 256,
                height: 256,
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                width: 256,
                height: 256,
                child: const Icon(
                  Icons.map_outlined,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            );
          },
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
        
        // Place markers - ปิดการแสดงผลไว้ก่อน
        // if (state is MapLoaded)
        //   MarkerLayer(
        //     markers: _buildMarkers(state),
        //   ),
      ],
    );
  }

  // List<Marker> _buildMarkers(MapLoaded state) {
  //   final List<Marker> markers = [];

  //   // Current location marker
  //   if (state.currentLocation != null) {
  //     markers.add(
  //       Marker(
  //         point: LatLng(
  //           state.currentLocation!.latitude,
  //           state.currentLocation!.longitude,
  //         ),
  //         width: 20,
  //         height: 20,
  //         child: Container(
  //           decoration: const BoxDecoration(
  //             shape: BoxShape.circle,
  //           ),
  //           child: const Icon(
  //             Icons.my_location,
  //             size: 12,
  //           ),
  //         ),
  //       ),
  //     );
  //   }

  //   // Place markers
  //   for (final place in state.filteredPlaces) {
  //     markers.add(
  //       Marker(
  //         point: LatLng(place.location.latitude, place.location.longitude),
  //         width: 40,
  //         height: 40,
  //         child: GestureDetector(
  //           onTap: () {
  //             context.read<MapBloc>().add(SelectPlace(place));
  //           },
  //           child: Container(
  //             decoration: const BoxDecoration(
  //               shape: BoxShape.circle,
  //             ),
  //             child: Icon(
  //               _getCategoryIcon(place.category),
  //               size: 20,
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   }

  //   return markers;
  // }

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

  void _showPlaceDetails(PlaceEntity place, BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => LocationDetailsBottomSheet(place: place),
    );
  }

  void _showLocationPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
          'This app needs location permission to show your current location on the map.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<MapBloc>().add(GetCurrentLocation());
            },
            child: const Text('Try Again'),
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
    return SizedBox(
      width: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultItem(
    BuildContext context,
    IconData icon,
    String name,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[600],
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 24,
            color: Colors.white,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () {
          // TODO: Navigate to selected place on map
          AppLogger.debug('Selected place: $name');
        },
      ),
    );
  }

  // IconData _getCategoryIcon(String category) {
  //   switch (category.toLowerCase()) {
  //     case 'library':
  //       return Icons.local_library;
  //     case 'building':
  //       return Icons.business;
  //     case 'restaurant':
  //       return Icons.restaurant;
  //     case 'sport':
  //       return Icons.sports_soccer;
  //     case 'dormitory':
  //       return Icons.hotel;
  //     case 'parking':
  //       return Icons.local_parking;
  //     case 'medical':
  //       return Icons.local_hospital;
  //     default:
  //       return Icons.place;
  //   }
  // }
}