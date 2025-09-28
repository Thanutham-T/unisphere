import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../../../core/logging/app_logger.dart';

class PlacesService {
  static const String _overpassUrl = 'https://overpass-api.de/api/interpreter';
  static const String _nominatimUrl = 'https://nominatim.openstreetmap.org';

  /// ค้นหาสถานที่รอบๆ จุดที่กำหนดจาก OpenStreetMap
  Future<List<Place>> searchNearbyPlaces({
    required LatLng center,
    required double radiusKm,
    List<String>? amenityTypes,
  }) async {
    // คำนวณ bounding box จากจุดกลางและรัศมี
    final bounds = _calculateBounds(center, radiusKm);
    
    // สร้าง Overpass query
    final amenityFilter = amenityTypes?.join('|') ?? 'restaurant|cafe|hospital|school|library|bank|pharmacy|fuel|atm';
    
    final query = '''
[out:json][timeout:25];
(
  node["amenity"~"$amenityFilter"]
    (${bounds['south']},${bounds['west']},${bounds['north']},${bounds['east']});
  way["amenity"~"$amenityFilter"]
    (${bounds['south']},${bounds['west']},${bounds['north']},${bounds['east']});
  relation["amenity"~"$amenityFilter"]
    (${bounds['south']},${bounds['west']},${bounds['north']},${bounds['east']});
  // Include specific university buildings
  node["building"~"university|college"]
    (${bounds['south']},${bounds['west']},${bounds['north']},${bounds['east']});
  way["building"~"university|college"]
    (${bounds['south']},${bounds['west']},${bounds['north']},${bounds['east']});
);
out center meta;
''';

    try {
      final response = await http.post(
        Uri.parse(_overpassUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'data=${Uri.encodeComponent(query)}',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final elements = data['elements'] as List;
        
        return elements.map((element) => Place.fromOverpassJson(element)).toList();
      } else {
        throw Exception('Failed to load places: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error fetching places', e);
      return [];
    }
  }

  /// ค้นหาสถานที่โดยใช้ชื่อ
  Future<List<Place>> searchPlacesByName({
    required String query,
    LatLng? nearLocation,
    int limit = 10,
  }) async {
    final searchUrl = Uri.parse(
      '$_nominatimUrl/search?'
      'q=${Uri.encodeComponent(query)}&'
      'format=json&'
      'limit=$limit&'
      'addressdetails=1&'
      'extratags=1'
    );

    try {
      final response = await http.get(
        searchUrl,
        headers: {'User-Agent': 'unisphere-app/1.0'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        
        return data.map((item) => Place.fromNominatimJson(item)).toList();
      } else {
        throw Exception('Failed to search places: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error searching places', e);
      return [];
    }
  }

  /// คำนวณ bounding box จากจุดกลางและรัศมี
  Map<String, double> _calculateBounds(LatLng center, double radiusKm) {
    const double earthRadiusKm = 6371.0;
    
    final latOffset = (radiusKm / earthRadiusKm) * (180 / 3.14159);
    final lngOffset = latOffset / cos(center.latitude * 3.14159 / 180);
    
    return {
      'north': center.latitude + latOffset,
      'south': center.latitude - latOffset,
      'east': center.longitude + lngOffset,
      'west': center.longitude - lngOffset,
    };
  }
}

class Place {
  final String id;
  final String name;
  final String? description;
  final LatLng location;
  final String category;
  final String? amenityType;
  final String? address;
  final String? phone;
  final String? website;
  final String? openingHours;
  final Map<String, dynamic>? additionalInfo;

  Place({
    required this.id,
    required this.name,
    this.description,
    required this.location,
    required this.category,
    this.amenityType,
    this.address,
    this.phone,
    this.website,
    this.openingHours,
    this.additionalInfo,
  });

  /// สร้าง Place จากข้อมูล Overpass API
  factory Place.fromOverpassJson(Map<String, dynamic> json) {
    final tags = json['tags'] as Map<String, dynamic>? ?? {};
    
    // ใช้ center สำหรับ way และ relation, ใช้ lat/lon สำหรับ node
    double lat, lon;
    if (json['center'] != null) {
      lat = json['center']['lat'].toDouble();
      lon = json['center']['lon'].toDouble();
    } else {
      lat = json['lat'].toDouble();
      lon = json['lon'].toDouble();
    }

    final name = tags['name'] ?? tags['name:th'] ?? tags['name:en'] ?? 'ไม่ระบุชื่อ';
    
    // เพิ่มข้อมูลโทรศัพท์และเว็บไซต์สำหรับสถานที่ที่ขาดข้อมูล
    String? phone = tags['phone'] ?? tags['contact:phone'];
    String? website = tags['website'] ?? tags['contact:website'] ?? tags['url'];
    
    // เพิ่มข้อมูลจำลองสำหรับสถานที่สำคัญที่ขาดข้อมูล
    final defaultContactInfo = _getDefaultContactInfo(name, tags['amenity']);
    phone ??= defaultContactInfo['phone'];
    website ??= defaultContactInfo['website'];

    return Place(
      id: json['id'].toString(),
      name: name,
      description: tags['description'],
      location: LatLng(lat, lon),
      category: _mapAmenityToCategory(tags['amenity'] ?? tags['building']),
      amenityType: tags['amenity'] ?? tags['building'],
      address: _buildAddress(tags),
      phone: phone,
      website: website,
      openingHours: tags['opening_hours'],
      additionalInfo: tags,
    );
  }

  /// สร้างที่อยู่จาก tags
  static String? _buildAddress(Map<String, dynamic> tags) {
    final parts = <String>[];
    if (tags['addr:housenumber'] != null) parts.add(tags['addr:housenumber']);
    if (tags['addr:street'] != null) parts.add(tags['addr:street']);
    if (tags['addr:subdistrict'] != null) parts.add(tags['addr:subdistrict']);
    if (tags['addr:district'] != null) parts.add(tags['addr:district']);
    if (tags['addr:province'] != null) parts.add(tags['addr:province']);
    if (tags['addr:postcode'] != null) parts.add(tags['addr:postcode']);
    
    return parts.isNotEmpty ? parts.join(' ') : tags['addr:full'];
  }

  /// ให้ข้อมูลติดต่อเริ่มต้นสำหรับสถานที่สำคัญ
  static Map<String, String?> _getDefaultContactInfo(String name, String? amenity) {
    final nameLower = name.toLowerCase();
    
    // มหาวิทยาลัยสงขลานครินทร์
    if (nameLower.contains('สงขลานครินทร์') || nameLower.contains('psu') || nameLower.contains('prince of songkla')) {
      if (nameLower.contains('วิศวกรรม') || nameLower.contains('engineering')) {
        return {'phone': '074-287000', 'website': 'https://www.eng.psu.ac.th'};
      }
      if (nameLower.contains('แพทย์') || nameLower.contains('medical') || nameLower.contains('medicine')) {
        return {'phone': '074-451000', 'website': 'https://www.med.psu.ac.th'};
      }
      if (nameLower.contains('หอสมุด') || nameLower.contains('library')) {
        return {'phone': '074-286174', 'website': 'https://lib.psu.ac.th'};
      }
      if (nameLower.contains('วิทยาศาสตร์') || nameLower.contains('science')) {
        return {'phone': '074-288300', 'website': 'https://www.sc.psu.ac.th'};
      }
      if (nameLower.contains('ศิลปศาสตร์') || nameLower.contains('liberal arts')) {
        return {'phone': '074-286801', 'website': 'https://www.la.psu.ac.th'};
      }
      // PSU General
      return {'phone': '074-286000', 'website': 'https://www.psu.ac.th'};
    }
    
    // โรงพยาบาล
    if (amenity == 'hospital' || nameLower.contains('โรงพยาบาล') || nameLower.contains('hospital')) {
      if (nameLower.contains('สงขลานครินทร์')) {
        return {'phone': '074-451000', 'website': 'https://www.songhospital.com'};
      }
      return {'phone': null, 'website': null}; // จะแสดงป๊อปอัพไม่มีข้อมูล
    }
    
    // ร้านอาหาร, คาเฟ่
    if (amenity == 'restaurant' || amenity == 'cafe') {
      return {'phone': null, 'website': null}; // ปกติร้านเล็กไม่มีเว็บไซต์
    }
    
    return {'phone': null, 'website': null};
  }

  /// สร้าง Place จากข้อมูล Nominatim API
  factory Place.fromNominatimJson(Map<String, dynamic> json) {
    return Place(
      id: json['place_id'].toString(),
      name: json['display_name'].split(',').first,
      description: json['display_name'],
      location: LatLng(
        double.parse(json['lat']),
        double.parse(json['lon']),
      ),
      category: _mapTypeToCategory(json['type']),
      amenityType: json['type'],
      address: json['display_name'],
      additionalInfo: json,
    );
  }

  /// แปลง amenity type เป็นหมวดหมู่ภาษาไทย
  static String _mapAmenityToCategory(String? amenity) {
    switch (amenity) {
      case 'restaurant':
        return 'ร้านอาหาร';
      case 'cafe':
        return 'ร้านกาแฟ';
      case 'hospital':
        return 'โรงพยาบาล';
      case 'clinic':
        return 'คลินิก';
      case 'school':
      case 'university':
      case 'college':
      case 'dormitory':
        return 'สถานศึกษา';
      case 'library':
        return 'ห้องสมุด';
      case 'bank':
        return 'ธนาคาร';
      case 'atm':
        return 'ตู้เอทีเอ็ม';
      case 'pharmacy':
        return 'ร้านขายยา';
      case 'fuel':
        return 'ปั๊มน้ำมัน';
      case 'marketplace':
        return 'ตลาด';
      case 'place_of_worship':
        return 'สถานที่ศักดิ์สิทธิ์';
      default:
        return 'อื่นๆ';
    }
  }

  static String _mapTypeToCategory(String? type) {
    return _mapAmenityToCategory(type);
  }
}