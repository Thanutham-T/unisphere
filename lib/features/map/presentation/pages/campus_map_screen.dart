import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/place_entity.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';
import '../bloc/map_state.dart';
import '../widgets/map_bottom_sheet.dart';
import '../widgets/navigation_bottom_sheet.dart';
import '../../data/services/places_service.dart';

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});

  @override
  State<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  // Constants
  static const LatLng _campusCenter = LatLng(7.0069451, 100.5007147);
  static const LatLng _testLocation = LatLng(7.004097, 100.500940);
  
  // Controllers
  static final MapController _mapController = MapController();
  static final ValueNotifier<String> _searchQuery = ValueNotifier('');
  
  // Services
  final PlacesService _placesService = PlacesService();
  
  // State variables
  List<Place> _realPlaces = [];
  bool _isLoadingPlaces = false;
  bool _showTestLocationMarker = false;
  bool _isNavigationActive = false;
  LatLng? _navigationDestination;
  String _destinationName = '';
  List<LatLng> _routePoints = [];





  void _onSearchChanged(String query, BuildContext context) {
    _searchQuery.value = query;
    AppLogger.debug('Search query: $query');
  }

  void _onSetMyLocationTap(BuildContext context) {
    try {
      // Move map to test location and show marker
      _mapController.move(_testLocation, 18.0);
      
      // Show test location marker
      setState(() {
        _showTestLocationMarker = true;
      });
      
      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.location_on, color: Theme.of(context).colorScheme.onPrimary),
              const SizedBox(width: 8),
              const Text('ระบุตำแหน่งทดสอบสำเร็จแล้ว'),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          duration: const Duration(seconds: 2),
        ),
      );
      
      AppLogger.debug('Test location set and map moved to: ${_testLocation.latitude}, ${_testLocation.longitude}');
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      AppLogger.debug('Error setting test location: $e');
    }
  }

  void _startNavigationToDestination(LatLng destination, String name) {
    if (!_showTestLocationMarker) {
      // Show message to set test location first
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณาระบุตำแหน่งของคุณก่อนเริ่มนำทาง'),
        ),
      );
      return;
    }

    setState(() {
      _isNavigationActive = true;
      _navigationDestination = destination;
      _destinationName = name;
      _routePoints = _calculateRoute(_testLocation, destination);
    });

    AppLogger.debug('Navigation started from ${_testLocation.latitude},${_testLocation.longitude} to ${destination.latitude},${destination.longitude}');
    AppLogger.debug('Destination: $_destinationName at ${_navigationDestination?.latitude},${_navigationDestination?.longitude}');
  }

  void _stopNavigation() {
    setState(() {
      _isNavigationActive = false;
      _navigationDestination = null;
      _destinationName = '';
      _routePoints = [];
    });
    AppLogger.debug('Navigation stopped');
  }

  void _showNavigationBottomSheet(BuildContext context, LatLng destination, String name) {
    // Find the place from real places to get additional data
    final place = _realPlaces.cast<Place?>().firstWhere(
      (place) => place?.name == name,
      orElse: () => null,
    );

    // Always calculate distance from test location (if set) or campus center
    final startPoint = _showTestLocationMarker ? _testLocation : _campusCenter;
    final distanceKm = _calculateDistance(startPoint, destination);
    final formattedDistance = _formatDistance(distanceKm);
    final estimatedTime = _calculateEstimatedTime(distanceKm);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NavigationBottomSheet(
        destinationName: name,
        destination: destination,
        distance: formattedDistance,
        estimatedTimeMinutes: estimatedTime,
        phoneNumber: place?.phone, // Use phone from OSM data
        website: place?.website, // Use website from OSM data
        onStartNavigation: () {
          Navigator.pop(context);
          if (_showTestLocationMarker) {
            _startNavigationToDestination(destination, name);
          } else {
            // Start navigation from campus center
            setState(() {
              _isNavigationActive = true;
              _navigationDestination = destination;
              _destinationName = name;
              _routePoints = _calculateRoute(_campusCenter, destination);
            });
            AppLogger.debug('Navigation started from campus center to $name');
          }
        },
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _onPlaceSelectedFromSearch(BuildContext context, Map<String, dynamic> placeData) {
    final destination = LatLng(placeData['lat'], placeData['lng']);
    final name = placeData['name'];
    
    // เลื่อนแผนที่ไปยังสถานที่ที่เลือก
    _mapController.move(destination, 16.0);
    
    // แสดง NavigationBottomSheet
    _showNavigationBottomSheet(context, destination, name);
  }

  List<LatLng> _calculateRoute(LatLng start, LatLng destination) {
    // Simple straight line route for demonstration
    // In a real app, you would use a routing service
    return [start, destination];
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Kilometer, start, end);
  }

  String _formatDistance(double distanceKm) {
    if (distanceKm < 1.0) {
      // Show in meters with no decimals if less than 1 km
      int meters = (distanceKm * 1000).round();
      return '${meters}m';
    } else {
      // Show in km with 1 decimal place
      return '${distanceKm.toStringAsFixed(1)}km';
    }
  }

  int _calculateEstimatedTime(double distanceKm) {
    // More realistic walking speed: 4.5 km/h for campus terrain
    double hours = distanceKm / 4.5;
    int minutes = (hours * 60).round();
    
    // Minimum 1 minute for very short distances
    return minutes < 1 ? 1 : minutes;
  }

  List<Map<String, dynamic>> _getFilteredPlaces(String query) {
    if (query.isEmpty) return [];
    
    // Filter real places from OSM data
    return _realPlaces
        .where((place) => place.name
            .toLowerCase()
            .contains(query.toLowerCase()))
        .map((place) => {
          'name': place.name,
          'icon': _getIconFromAmenity(place.amenityType),
          'lat': place.location.latitude,
          'lng': place.location.longitude,
        })
        .toList();
  }

  /// สร้างปุ่มควบคุมแมพ
  Widget _buildMapControlButtons(BuildContext context) {
    // Capture the context that has access to MapBloc
    final blocContext = context;
    
    return Positioned(
      right: 16,
      top: 100, // ด้านล่าง AppBar
      child: Column(
        children: [
          // ปุ่มกลับไปยังตำแหน่งมหาวิทยาลัย
          Tooltip(
            message: 'กลับไปยังตำแหน่งมหาวิทยาลัย',
            child: FloatingActionButton(
              heroTag: "campus_center",
              mini: true,
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.primary,
              elevation: 4,
              onPressed: () => _moveToCampusCenter(),
              child: const Icon(Icons.school), // ไอคอนมหาวิทยาลัย
            ),
          ),
          
          const SizedBox(height: 8),
          
          // ปุ่มหาตำแหน่งของฉัน
          Tooltip(
            message: 'หาตำแหน่งของฉัน',
            child: FloatingActionButton(
              heroTag: "my_location",
              mini: true,
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.primary,
              elevation: 4,
              onPressed: () {
                try {
                  blocContext.read<MapBloc>().add(GetCurrentLocation());
                  AppLogger.debug('Requesting current location');
                } catch (e) {
                  AppLogger.debug('Error requesting location: $e');
                  ScaffoldMessenger.of(blocContext).showSnackBar(
                    SnackBar(
                      content: const Text('ไม่สามารถขอสิทธิ์เข้าถึงตำแหน่งได้ กรุณาลองใหม่อีกครั้ง'),
                      backgroundColor: Theme.of(blocContext).colorScheme.error,
                    ),
                  );
                }
              },
              child: const Icon(Icons.my_location),
            ),
          ),

          const SizedBox(height: 8),

          // ปุ่มรีเฟรชข้อมูลสถานที่
          Tooltip(
            message: 'รีเฟรชข้อมูลสถานที่',
            child: FloatingActionButton(
              heroTag: "refresh_places",
              mini: true,
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: _isLoadingPlaces 
                ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                : Theme.of(context).colorScheme.primary,
              elevation: 4,
              onPressed: _isLoadingPlaces ? null : () {
                _loadRealPlaces();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('กำลังรีเฟรชข้อมูลสถานที่...')),
                );
              },
              child: _isLoadingPlaces 
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : const Icon(Icons.refresh),
            ),
          ),

          const SizedBox(height: 8),

          // ปุ่มระบุตำแหน่งของฉัน (ทดสอบนำทาง) หรือหยุดการนำทาง
          Tooltip(
            message: _isNavigationActive 
              ? 'หยุดการนำทาง' 
              : 'ระบุตำแหน่งของฉัน (ทดสอบนำทาง)',
            child: FloatingActionButton(
              heroTag: "set_test_location",
              mini: true,
              backgroundColor: _isNavigationActive
                ? Theme.of(context).colorScheme.errorContainer
                : _showTestLocationMarker 
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surface,
              foregroundColor: _isNavigationActive
                ? Theme.of(context).colorScheme.onErrorContainer
                : _showTestLocationMarker 
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.primary,
              elevation: 4,
              onPressed: () {
                if (_isNavigationActive) {
                  _stopNavigation();
                } else {
                  _onSetMyLocationTap(context);
                }
              },
              child: Icon(_isNavigationActive 
                ? Icons.stop 
                : Icons.location_searching),
            ),
          ),
        ],
      ),
    );
  }

  /// เลื่อนแมพไปยังตำแหน่งมหาวิทยาลัย
  void _moveToCampusCenter() {
    _mapController.move(_campusCenter, 16.0);
    AppLogger.debug('Moved to campus center: $_campusCenter');
  }



  /// สร้าง status card สำหรับแสดงสถานะต่างๆ
  Widget _buildStatusCard(BuildContext context, String message, {double? bottom}) {
    return Positioned(
      bottom: bottom ?? 100,
      left: 16,
      right: 16,
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

















  @override
  void initState() {
    super.initState();
    _loadRealPlaces();
  }

  /// โหลดข้อมูลสถานที่จริงจาก OpenStreetMap
  Future<void> _loadRealPlaces() async {
    setState(() {
      _isLoadingPlaces = true;
    });

    try {
      final places = await _placesService.searchNearbyPlaces(
        center: _campusCenter,
        radiusKm: 5.0, // ค้นหารัศมี 5 กิโลเมตร
        amenityTypes: [
          'restaurant', 'cafe', 'hospital', 'clinic', 
          'school', 'university', 'library', 'bank', 
          'atm', 'pharmacy', 'fuel', 'marketplace'
        ],
      );

      setState(() {
        _realPlaces = places;
        _isLoadingPlaces = false;
      });

      AppLogger.debug('โหลดสถานที่จริงได้ ${places.length} แห่ง');
    } catch (e) {
      setState(() {
        _isLoadingPlaces = false;
      });
      AppLogger.debug('เกิดข้อผิดพลาดในการโหลดสถานที่: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize map when widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapBloc>().add(InitializeMap());
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoadingPlaces 
          ? 'Map (กำลังโหลด...)'
          : 'Map (${_realPlaces.length} สถานที่)'
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // ปุ่มจัดการแผนที่ออฟไลน์
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) => _handleOfflineMenuAction(context, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'download',
                child: ListTile(
                  leading: Icon(Icons.download),
                  title: Text('ดาวน์โหลดแผนที่ออฟไลน์'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'status',
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text('สถานะแผนที่ออฟไลน์'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'test',
                child: ListTile(
                  leading: Icon(Icons.bug_report),
                  title: Text('ทดสอบการดาวน์โหลด'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
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
            // แสดงข้อความยืนยันการหาตำแหน่งสำเร็จ
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('พบตำแหน่งของคุณแล้ว'),
                duration: const Duration(seconds: 2),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Main Map
              _buildMap(state, context),
              
              // Map Control Buttons
              _buildMapControlButtons(context),
              
              // Draggable Bottom Sheet
              DraggableScrollableSheet(
                initialChildSize: 0.35,
                minChildSize: 0.15,
                maxChildSize: 0.35,
                snap: true,
                snapSizes: const [0.15, 0.35],
                builder: (context, scrollController) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate if we should show full content based on container height
                      final screenHeight = MediaQuery.of(context).size.height;
                      final currentHeight = constraints.maxHeight;
                      final sizeRatio = currentHeight / screenHeight;
                      final showFullContent = sizeRatio > 0.25;
                      
                      return ValueListenableBuilder<String>(
                        valueListenable: _searchQuery,
                        builder: (context, searchQuery, child) {
                          final filteredPlaces = _getFilteredPlaces(searchQuery);
                          
                          return MapBottomSheet(
                            scrollController: scrollController,
                            searchQuery: searchQuery,
                            filteredPlaces: filteredPlaces,
                            categoryPlaces: _realPlaces.map((place) => {
                              'name': place.name,
                              'icon': _getIconFromAmenity(place.amenityType),
                            }).toList(),
                            onSearchChanged: (query) => _onSearchChanged(query, context),
                            showFullContent: showFullContent,
                            onPlaceSelected: (placeData) => _onPlaceSelectedFromSearch(context, placeData),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              
              // Loading indicator
              if (state is MapLoading || _isLoadingPlaces)
                Container(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isLoadingPlaces 
                            ? 'กำลังโหลดข้อมูลสถานที่จาก OpenStreetMap...'
                            : 'กำลังโหลดแมพ...',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              
              // Route calculating indicator
              if (state is RouteCalculating)
                _buildStatusCard(
                  context, 
                  'กำลังคำนวณเส้นทาง...', 
                  bottom: 100
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
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                width: 256,
                height: 256,
              ),
              errorWidget: (context, url, error) => Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                width: 256,
                height: 256,
                child: Icon(
                  Icons.map_outlined,
                  size: 50,
                  color: Theme.of(context).hintColor,
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

        // Navigation route polyline
        if (_isNavigationActive && _routePoints.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: _routePoints,
                strokeWidth: 5.0,
                color: Theme.of(context).colorScheme.primary,
                borderStrokeWidth: 2.0,
                borderColor: Colors.white,
              ),
            ],
          ),
        
        // Place markers
        MarkerLayer(
          markers: _buildMarkers(state, context),
        ),
      ],
    );
  }

  List<Marker> _buildMarkers(MapState state, BuildContext context) {
    final List<Marker> markers = [];

    // Current location marker
    if (state is MapLoaded && state.currentLocation != null) {
      markers.add(
        Marker(
          point: LatLng(
            state.currentLocation!.latitude,
            state.currentLocation!.longitude,
          ),
          width: 24,
          height: 24,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: const Icon(
              Icons.my_location,
              size: 12,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    // Test location marker for navigation testing
    if (_showTestLocationMarker) {
      markers.add(
        Marker(
          point: _testLocation,
          width: 32,
          height: 32,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.location_searching,
              size: 18,
              color: Theme.of(context).colorScheme.onTertiary,
            ),
          ),
        ),
      );
    }

    // Place markers from real OSM data
    for (final place in _realPlaces) {
      markers.add(
        Marker(
          point: place.location,
          width: 30,
          height: 30,
          child: GestureDetector(
            onTap: () {
              // Focus on the selected place
              _mapController.move(place.location, 18.0);
              // Show navigation bottom sheet for OSM places
              _showNavigationBottomSheet(context, place.location, place.name);
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: _getMarkerColorFromCategory(place.category),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Icon(
                _getIconFromAmenity(place.amenityType),
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    // OSM places are already handled above in the real places loop

    return markers;
  }



  Color _getMarkerColorFromCategory(String category) {
    switch (category) {
      case 'ร้านกาแฟ':
        return Colors.brown;
      case 'ร้านอาหาร':
        return Colors.orange;
      case 'ห้องสมุด':
        return Colors.blue;
      case 'โรงพยาบาล':
      case 'คลินิก':
        return Colors.red;
      case 'สถานศึกษา':
        return Colors.green;
      case 'ตลาด':
        return Colors.purple;
      case 'ธนาคาร':
        return Colors.indigo;
      case 'ตู้เอทีเอ็ม':
        return Colors.cyan;
      case 'ร้านขายยา':
        return Colors.pink;
      case 'ปั๊มน้ำมัน':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconFromAmenity(String? amenityType) {
    switch (amenityType) {
      case 'restaurant':
        return Icons.restaurant;
      case 'cafe':
        return Icons.local_cafe;
      case 'hospital':
        return Icons.local_hospital;
      case 'clinic':
        return Icons.medical_services;
      case 'school':
      case 'university':
        return Icons.school;
      case 'library':
        return Icons.local_library;
      case 'bank':
        return Icons.account_balance;
      case 'atm':
        return Icons.atm;
      case 'pharmacy':
        return Icons.local_pharmacy;
      case 'fuel':
        return Icons.local_gas_station;
      case 'marketplace':
        return Icons.store;
      case 'place_of_worship':
        return Icons.temple_buddhist;
      default:
        return Icons.place;
    }
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

  void _showPlaceDetails(PlaceEntity place, BuildContext context) {
    // Show simple dialog for place details
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(place.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ประเภท: ${place.category}'),
            if (place.description != null) 
              Text('รายละเอียด: ${place.description}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  void _showLocationPermissionDialog(BuildContext context) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'จำเป็นต้องใช้สิทธิ์การเข้าถึงตำแหน่ง',
          style: theme.textTheme.titleLarge,
        ),
        content: Text(
          'แอปต้องการสิทธิ์การเข้าถึงตำแหน่งเพื่อแสดงตำแหน่งปัจจุบันของคุณบนแผนที่',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'ยกเลิก',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<MapBloc>().add(GetCurrentLocation());
            },
            child: const Text('ลองอีกครั้ง'),
          ),
        ],
      ),
    );
  }

  void _handleOfflineMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'download':
        _showOfflineDownloadDialog(context);
        break;
      case 'status':
        _showOfflineStatusDialog(context);
        break;
      case 'test':
        _showTestDownloadPage(context);
        break;
    }
  }

  void _showOfflineDownloadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ดาวน์โหลดแผนที่ออฟไลน์'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🗺️ พื้นที่: มหาวิทยาลัยและบริเวณโดยรอบ (รัศมี 2 กม.)'),
            Text('🔍 ระดับซูม: 10-19 (รายละเอียดสูง)'),
            Text('💾 ขนาดโดยประมาณ: ~50 MB'),
            Text('📱 จัดเก็บ: ในเครื่องของคุณ (ใช้ได้แม้ไม่มีอินเทอร์เน็ต)'),
            SizedBox(height: 16),
            Text('⚠️ การดาวน์โหลดอาจใช้เวลา 2-5 นาที\nตรวจสอบให้แน่ใจว่าเชื่อมต่ออินเทอร์เน็ตและมีพื้นที่เก็บข้อมูลเพียงพอ'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startOfflineDownload(context);
            },
            child: const Text('เริ่มดาวน์โหลด'),
          ),
        ],
      ),
    );
  }

  void _showOfflineStatusDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('สถานะแผนที่ออฟไลน์'),
        content: FutureBuilder<Map<String, dynamic>>(
          future: _getOfflineMapStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('กำลังตรวจสอบ...'),
                ],
              );
            }
            
            final data = snapshot.data ?? {};
            final hasCache = data['hasCache'] ?? false;
            final cacheSizeMB = data['cacheSizeMB'] ?? 0.0;
            final tileCount = data['tileCount'] ?? 0;
            
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('พื้นที่ที่เก็บแคช: มหาวิทยาลัยและบริเวณโดยรอบ'),
                Text('ระดับซูม: 10-19'),
                Text('ขนาดแคช: ${cacheSizeMB.toStringAsFixed(1)} MB'),
                Text('จำนวน tiles: $tileCount'),
                Text('สถานะ: ${hasCache ? "พร้อมใช้งานออฟไลน์" : "ยังไม่ได้ดาวน์โหลด"}'),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> _getOfflineMapStatus() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final cacheDir = Directory('${directory.path}/offline_tiles');
      
      if (!await cacheDir.exists()) {
        return {
          'hasCache': false,
          'cacheSizeMB': 0.0,
          'tileCount': 0,
        };
      }
      
      int tileCount = 0;
      double totalSizeBytes = 0;
      
      await for (final entity in cacheDir.list(recursive: true)) {
        if (entity is File && entity.path.endsWith('.png')) {
          tileCount++;
          final stat = await entity.stat();
          totalSizeBytes += stat.size;
        }
      }
      
      return {
        'hasCache': tileCount > 0,
        'cacheSizeMB': totalSizeBytes / (1024 * 1024),
        'tileCount': tileCount,
      };
    } catch (e) {
      AppLogger.error('Error getting offline status', e);
      return {
        'hasCache': false,
        'cacheSizeMB': 0.0,
        'tileCount': 0,
      };
    }
  }

  void _showTestDownloadPage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ทดสอบการดาวน์โหลด'),
        content: FutureBuilder<bool>(
          future: _testTileDownload(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('กำลังทดสอบการดาวน์โหลด...'),
                ],
              );
            }
            
            final success = snapshot.data ?? false;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  success ? Icons.check_circle : Icons.error,
                  color: success ? Colors.green : Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  success 
                    ? 'การทดสอบสำเร็จ!\nสามารถดาวน์โหลดแผนที่ออฟไลน์ได้'
                    : 'การทดสอบล้มเหลว\nตรวจสอบการเชื่อมต่ออินเทอร์เน็ต',
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด'),
          ),
        ],
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

  Future<void> _startOfflineDownload(BuildContext context) async {
    final ValueNotifier<String> progressText = ValueNotifier('เตรียมการดาวน์โหลด...');
    final ValueNotifier<double> progressValue = ValueNotifier(0.0);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('กำลังดาวน์โหลดแผนที่ออฟไลน์'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<double>(
              valueListenable: progressValue,
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                );
              },
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<String>(
              valueListenable: progressText,
              builder: (context, text, child) {
                return Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                );
              },
            ),
            const SizedBox(height: 8),
            const Text(
              'กรุณารอสักครู่ การดาวน์โหลดจะใช้เวลาประมาณ 2-5 นาที\nแผนที่จะถูกเก็บไว้ในเครื่องของคุณสำหรับใช้งานออฟไลน์',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    try {
      final success = await _downloadMapTiles(progressText, progressValue);
      if (mounted) {
        Navigator.pop(context); // ปิด dialog กำลังดาวน์โหลด
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success 
              ? 'ดาวน์โหลดแผนที่ออฟไลน์สำเร็จ! แผนที่ถูกเก็บไว้ในเครื่องของคุณแล้ว'
              : 'ดาวน์โหลดล้มเหลว กรุณาลองใหม่'),
            backgroundColor: success ? Colors.green : Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // ปิด dialog กำลังดาวน์โหลด
        AppLogger.error('Download failed', e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('เกิดข้อผิดพลาดในการดาวน์โหลด'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<bool> _downloadMapTiles(ValueNotifier<String> progressText, ValueNotifier<double> progressValue) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final cacheDir = Directory('${directory.path}/offline_tiles');
      
      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }

      AppLogger.debug('แผนที่ออฟไลน์จะถูกเก็บไว้ที่: ${cacheDir.path}');
      progressText.value = 'กำลังคำนวณขนาดการดาวน์โหลด...';

      // University area bounds
      const double centerLat = 7.0069451;
      const double centerLng = 100.5007147;
      const double radiusKm = 2.0; // 2km radius
      
      // Calculate total tiles first
      int totalTiles = 0;
      for (int zoom = 10; zoom <= 19; zoom++) {
        final bounds = _getTileBounds(centerLat, centerLng, radiusKm, zoom);
        totalTiles += (bounds['maxX']! - bounds['minX']! + 1) * (bounds['maxY']! - bounds['minY']! + 1);
      }
      
      AppLogger.debug('จำนวน tiles ทั้งหมดที่ต้องดาวน์โหลด: $totalTiles');
      
      int processedTiles = 0;
      int downloadedTiles = 0;
      int skippedTiles = 0;
      
      for (int zoom = 10; zoom <= 19; zoom++) {
        final bounds = _getTileBounds(centerLat, centerLng, radiusKm, zoom);
        progressText.value = 'กำลังดาวน์โหลดระดับซูม $zoom...';
        
        for (int x = bounds['minX']!; x <= bounds['maxX']!; x++) {
          for (int y = bounds['minY']!; y <= bounds['maxY']!; y++) {
            processedTiles++;
            
            final tileFile = File('${cacheDir.path}/$zoom/$x/$y.png');
            if (!await tileFile.exists()) {
              await tileFile.parent.create(recursive: true);
              
              final url = 'https://tile.openstreetmap.org/$zoom/$x/$y.png';
              try {
                final response = await http.get(Uri.parse(url));
                if (response.statusCode == 200) {
                  await tileFile.writeAsBytes(response.bodyBytes);
                  downloadedTiles++;
                } else {
                  AppLogger.debug('HTTP error ${response.statusCode} for tile $url');
                }
              } catch (e) {
                AppLogger.error('Failed to download tile $url', e);
              }
              
              // Add small delay to avoid overwhelming the server
              await Future.delayed(const Duration(milliseconds: 50));
            } else {
              skippedTiles++;
            }
            
            // Update progress
            final progress = processedTiles / totalTiles;
            progressValue.value = progress;
            final percentage = (progress * 100).toInt();
            progressText.value = 'ดาวน์โหลดแล้ว $downloadedTiles tiles ($percentage%)\nข้าม $skippedTiles tiles ที่มีอยู่แล้ว';
          }
        }
      }
      
      final totalSuccess = downloadedTiles + skippedTiles;
      AppLogger.debug('ดาวน์โหลดเสร็จสิ้น: $downloadedTiles tiles ใหม่, ข้าม $skippedTiles tiles, รวม $totalSuccess/$totalTiles tiles');
      progressText.value = 'ดาวน์โหลดเสร็จสิ้น! $totalSuccess tiles พร้อมใช้งาน';
      
      return totalSuccess > 0;
    } catch (e) {
      AppLogger.error('Tile download error', e);
      progressText.value = 'เกิดข้อผิดพลาดในการดาวน์โหลด';
      return false;
    }
  }

  Map<String, int> _getTileBounds(double lat, double lng, double radiusKm, int zoom) {
    final tileSize = 256;
    final earthRadius = 6378137; // meters
    final metersPerPixel = earthRadius * 2 * 3.14159265359 / tileSize / pow(2, zoom);
    
    // Convert radius to pixels
    final radiusPixels = (radiusKm * 1000 / metersPerPixel).round();
    
    // Get center tile
    final centerTileX = ((lng + 180) / 360 * pow(2, zoom)).floor();
    final centerTileY = ((1 - log(tan(lat * 3.14159265359 / 180) + 1 / cos(lat * 3.14159265359 / 180)) / 3.14159265359) / 2 * pow(2, zoom)).floor();
    
    // Calculate bounds
    final tilesToCover = (radiusPixels / tileSize).ceil();
    
    return {
      'minX': (centerTileX - tilesToCover).clamp(0, pow(2, zoom).toInt() - 1),
      'maxX': (centerTileX + tilesToCover).clamp(0, pow(2, zoom).toInt() - 1),
      'minY': (centerTileY - tilesToCover).clamp(0, pow(2, zoom).toInt() - 1),
      'maxY': (centerTileY + tilesToCover).clamp(0, pow(2, zoom).toInt() - 1),
    };
  }

  Future<bool> _testTileDownload() async {
    try {
      // Test downloading a single tile
      final url = 'https://tile.openstreetmap.org/15/25165/16302.png'; // Campus area tile
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        AppLogger.debug('Test tile download successful');
        return true;
      } else {
        AppLogger.debug('Test tile download failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      AppLogger.error('Test tile download error', e);
      return false;
    }
  }
}

