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
import '../widgets/map_bottom_sheet.dart';
import '../widgets/offline_map_download_dialog.dart';
import '../../core/services/map_tile_prefetcher.dart';
import '../../data/services/places_service.dart';
import 'test_offline_download.dart';

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});

  @override
  State<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  // Static controllers for stateless implementation
  static final MapController _mapController = MapController();
  static final ValueNotifier<String> _searchQuery = ValueNotifier('');
  
  // Default campus center (adjust to your campus coordinates)
  static const LatLng _campusCenter = LatLng(7.0069451, 100.5007147);

  // Places service และข้อมูลสถานที่จริง
  final PlacesService _placesService = PlacesService();
  List<Place> _realPlaces = [];
  bool _isLoadingPlaces = false;



  // Mock data for places with coordinates and detailed info
  static const List<Map<String, dynamic>> _warehousePlaces = [
    {
      'name': 'คณะวิศวกรรมศาสตร์', 
      'icon': Icons.school,
      'lat': 7.0069451,
      'lng': 100.5007147,
      'category': 'คณะ',
      'description': 'คณะวิศวกรรมศาสตร์ มหาวิทยาลยัสงขลานครินทร์',
      'openStatus': 'เปิด',
      'distance': '2.0 กม.',
      'rating': 4.5,
    },
    {
      'name': 'หอสมุดคุณหญิงหลง', 
      'icon': Icons.local_library,
      'lat': 7.0089451,
      'lng': 100.5027147,
      'category': 'ห้องสมุด',
      'description': 'ห้องสมุดกลางของมหาวิทยาลัย',
      'openStatus': 'เปิด',
      'distance': '1.8 กม.',
      'rating': 4.7,
    },
    {
      'name': 'Starbucks', 
      'icon': Icons.local_cafe,
      'lat': 7.0049451,
      'lng': 100.4987147,
      'category': 'ร้านกาแฟ',
      'description': 'ร้านกาแฟ • มหาวิทยาลัยสงขลานครินทร์',
      'openStatus': 'เปิดใหม่',
      'distance': '1.2 กม.',
      'rating': 4.3,
    },
    {
      'name': 'ตลาดเกษตร มอ', 
      'icon': Icons.store,
      'lat': 7.0029451,
      'lng': 100.5047147,
      'category': 'ตลาด',
      'description': 'ตลาดสดของมหาวิทยาลัย',
      'openStatus': 'เปิด',
      'distance': '2.5 กม.',
      'rating': 4.2,
    },
    {
      'name': 'โรงพยาบาล มอ', 
      'icon': Icons.local_hospital,
      'lat': 7.0109451,
      'lng': 100.5067147,
      'category': 'โรงพยาบาล',
      'description': 'โรงพยาบาลมหาวิทยาลัยสงขลานครินทร์',
      'openStatus': 'เปิด 24 ชม.',
      'distance': '3.1 กม.',
      'rating': 4.6,
    },
    {
      'name': 'โรงอาหาร', 
      'icon': Icons.restaurant,
      'lat': 7.0059451,
      'lng': 100.5017147,
      'category': 'ร้านอาหาร',
      'description': 'โรงอาหารกลางมหาวิทยาลัย',
      'openStatus': 'เปิด',
      'distance': '1.5 กม.',
      'rating': 4.1,
    },
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

  /// สร้างปุ่มควบคุมแมพ
  Widget _buildMapControlButtons(BuildContext context) {
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
              onPressed: () => _getCurrentLocation(context),
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
        ],
      ),
    );
  }

  /// เลื่อนแมพไปยังตำแหน่งมหาวิทยาลัย
  void _moveToCampusCenter() {
    _mapController.move(_campusCenter, 16.0);
    AppLogger.debug('Moved to campus center: $_campusCenter');
  }

  /// หาตำแหน่งปัจจุบันของผู้ใช้
  void _getCurrentLocation(BuildContext context) {
    context.read<MapBloc>().add(GetCurrentLocation());
    AppLogger.debug('Requesting current location');
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

  /// แสดง bottom sheet พร้อมรายละเอียดสถานที่
  void _showPlaceDetailsBottomSheet(BuildContext context, Map<String, dynamic> place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Place name
                    Text(
                      place['name'] as String,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Category and description
                    Text(
                      '${place['category']} • ${place['description']}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Action buttons row
                    Row(
                      children: [
                        // Directions button
                        Expanded(
                          child: _buildActionButton(
                            context,
                            icon: Icons.directions_car,
                            label: '2 นาที',
                            subtitle: 'เส้นทาง',
                            onTap: () {
                              // Handle directions
                              Navigator.pop(context);
                              _getDirectionsToPlace(place);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('กำลังหาเส้นทางไป ${place['name']}')),
                              );
                            },
                          ),
                        ),
                        
                        const SizedBox(width: 12),
                        
                        // Call button
                        Expanded(
                          child: _buildActionButton(
                            context,
                            icon: Icons.phone,
                            label: 'โทร',
                            subtitle: '',
                            onTap: () {
                              // Handle call
                              Navigator.pop(context);
                              _callPlace(place);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('โทรหา ${place['name']}')),
                              );
                            },
                          ),
                        ),
                        
                        const SizedBox(width: 12),
                        
                        // Website/More info button
                        Expanded(
                          child: _buildActionButton(
                            context,
                            icon: Icons.language,
                            label: 'เว็บไซต์',
                            subtitle: '',
                            onTap: () {
                              // Handle website
                              Navigator.pop(context);
                              _openWebsite(place);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('เปิดเว็บไซต์ ${place['name']}')),
                              );
                            },
                          ),
                        ),
                        
                        const SizedBox(width: 12),
                        
                        // Favorite button
                        Expanded(
                          child: _buildActionButton(
                            context,
                            icon: Icons.star_border,
                            label: 'บันทึก',
                            subtitle: '',
                            onTap: () {
                              // Handle save
                              _toggleFavorite(place);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('บันทึก ${place['name']} แล้ว')),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Additional info
                    Row(
                      children: [
                        const Text('จากที่ตั้ง:'),
                        const SizedBox(width: 8),
                        Text(
                          place['distance'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Row(
                      children: [
                        const Text('สถานะ:'),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor(place['openStatus'] as String),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            place['openStatus'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'เปิด':
        return Colors.green;
      case 'เปิดใหม่':
        return Colors.blue;
      case 'เปิด 24 ชม.':
        return Colors.purple;
      case 'ปิด':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _getDirectionsToPlace(Map<String, dynamic> place) {
    // Implement directions functionality - will be implemented later
    AppLogger.debug('Getting directions to ${place['name']}');
  }

  void _callPlace(Map<String, dynamic> place) {
    // Implement call functionality - will be implemented later
    AppLogger.debug('Calling ${place['name']}');
  }

  void _openWebsite(Map<String, dynamic> place) {
    // Implement website functionality - will be implemented later
    AppLogger.debug('Opening website for ${place['name']}');
  }

  void _toggleFavorite(Map<String, dynamic> place) {
    // Implement favorite functionality - will be implemented later
    AppLogger.debug('Toggling favorite for ${place['name']}');
  }

  /// แสดง bottom sheet สำหรับสถานที่จริงจาก OSM
  void _showRealPlaceDetailsBottomSheet(BuildContext context, Place place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Place name
                    Text(
                      place.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Category and description
                    Text(
                      '${place.category} • ${place.amenityType ?? ''}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Address
                    if (place.address != null && place.address!.isNotEmpty)
                      Text(
                        place.address!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    
                    const SizedBox(height: 16),
                    
                    // Action buttons row
                    Row(
                      children: [
                        // Directions button
                        Expanded(
                          child: _buildActionButton(
                            context,
                            icon: Icons.directions_car,
                            label: 'เส้นทาง',
                            subtitle: '',
                            onTap: () {
                              Navigator.pop(context);
                              _getRealDirectionsToPlace(place);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('กำลังหาเส้นทางไป ${place.name}')),
                              );
                            },
                          ),
                        ),
                        
                        const SizedBox(width: 12),
                        
                        // Call button (if phone available)
                        if (place.phone != null)
                          Expanded(
                            child: _buildActionButton(
                              context,
                              icon: Icons.phone,
                              label: 'โทร',
                              subtitle: '',
                              onTap: () {
                                Navigator.pop(context);
                                _callRealPlace(place);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('โทรหา ${place.name}')),
                                );
                              },
                            ),
                          ),
                        
                        if (place.phone != null) const SizedBox(width: 12),
                        
                        // Website button (if website available)
                        if (place.website != null)
                          Expanded(
                            child: _buildActionButton(
                              context,
                              icon: Icons.language,
                              label: 'เว็บไซต์',
                              subtitle: '',
                              onTap: () {
                                Navigator.pop(context);
                                _openRealWebsite(place);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('เปิดเว็บไซต์ ${place.name}')),
                                );
                              },
                            ),
                          ),
                        
                        if (place.website != null) const SizedBox(width: 12),
                        
                        // Favorite button
                        Expanded(
                          child: _buildActionButton(
                            context,
                            icon: Icons.star_border,
                            label: 'บันทึก',
                            subtitle: '',
                            onTap: () {
                              _toggleRealFavorite(place);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('บันทึก ${place.name} แล้ว')),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Opening hours
                    if (place.openingHours != null && place.openingHours!.isNotEmpty)
                      Row(
                        children: [
                          const Text('เวลาเปิด-ปิด:'),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              place.openingHours!,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    
                    const SizedBox(height: 8),
                    
                    // Coordinates for debugging
                    Text(
                      'ตำแหน่ง: ${place.location.latitude.toStringAsFixed(6)}, ${place.location.longitude.toStringAsFixed(6)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getRealDirectionsToPlace(Place place) {
    AppLogger.debug('Getting directions to ${place.name}');
  }

  void _callRealPlace(Place place) {
    AppLogger.debug('Calling ${place.name} at ${place.phone}');
  }

  void _openRealWebsite(Place place) {
    AppLogger.debug('Opening website for ${place.name}: ${place.website}');
  }

  void _toggleRealFavorite(Place place) {
    AppLogger.debug('Toggling favorite for ${place.name}');
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
          // Cache status indicator
          Tooltip(
            message: 'แผนที่รองรับการใช้งานออฟไลน์',
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                Icons.offline_pin,
                color: Theme.of(context).colorScheme.secondary,
                size: 24,
              ),
            ),
          ),
          
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
                            categoryPlaces: _warehousePlaces,
                            onSearchChanged: (query) => _onSearchChanged(query, context),
                            showFullContent: showFullContent,
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
                color: Theme.of(context).colorScheme.surfaceVariant,
                width: 256,
                height: 256,
              ),
              errorWidget: (context, url, error) => Container(
                color: Theme.of(context).colorScheme.surfaceVariant,
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
          width: 30,
          height: 30,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(
              Icons.my_location,
              size: 16,
              color: Colors.white,
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
          width: 40,
          height: 50,
          child: GestureDetector(
            onTap: () {
              // Focus on the selected place
              _mapController.move(place.location, 18.0);
              // Show place details
              _showRealPlaceDetailsBottomSheet(context, place);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getMarkerColorFromCategory(place.category),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getIconFromAmenity(place.amenityType),
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                // Small arrow pointing down
                Icon(
                  Icons.arrow_drop_down,
                  color: _getMarkerColorFromCategory(place.category),
                  size: 12,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // เพิ่ม mock data สำหรับทดสอบ (จะลบออกในภายหลัง)
    for (final place in _warehousePlaces) {
      markers.add(
        Marker(
          point: LatLng(place['lat'] as double, place['lng'] as double),
          width: 40,
          height: 50,
          child: GestureDetector(
            onTap: () {
              // Focus on the selected place
              _mapController.move(
                LatLng(place['lat'] as double, place['lng'] as double), 
                18.0
              );
              // Show place details
              _showPlaceDetailsBottomSheet(context, place);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getMarkerColor(place['category'] as String),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    place['icon'] as IconData,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                // Small arrow pointing down
                Icon(
                  Icons.arrow_drop_down,
                  color: _getMarkerColor(place['category'] as String),
                  size: 12,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return markers;
  }

  Color _getMarkerColor(String category) {
    switch (category) {
      case 'ร้านกาแฟ':
        return Colors.brown;
      case 'ร้านอาหาร':
        return Colors.orange;
      case 'ห้องสมุด':
        return Colors.blue;
      case 'โรงพยาบาล':
        return Colors.red;
      case 'คณะ':
        return Colors.green;
      case 'ตลาด':
        return Colors.purple;
      default:
        return Colors.grey;
    }
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => LocationDetailsBottomSheet(place: place),
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
      builder: (context) => const OfflineMapDownloadDialog(),
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
      // ใช้ MapTilePrefetcher เพื่อตรวจสอบสถานะ
      final prefetcher = MapTilePrefetcher();
      final cacheSize = await prefetcher.getCacheSize();
      final cacheSizeMB = cacheSize / 1024 / 1024;
      
      // ประมาณการจำนวน tiles (25KB ต่อ tile โดยเฉลี่ย)
      final estimatedTileCount = (cacheSize / 25000).round();
      
      return {
        'hasCache': cacheSize > 0,
        'cacheSizeMB': cacheSizeMB,
        'tileCount': estimatedTileCount,
      };
    } catch (e) {
      return {
        'hasCache': false,
        'cacheSizeMB': 0.0,
        'tileCount': 0,
      };
    }
  }

  void _showTestDownloadPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TestOfflineDownload(),
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

