import 'package:latlong2/latlong.dart';
import '../services/map_tile_prefetcher.dart';

class OfflineMapConfig {
  // กำหนดขอบเขตพื้นที่มหาวิทยาลัย (ปรับตามพื้นที่จริง)
  static const LatLng universityCenter = LatLng(7.0069451, 100.5007147);
  
  // ขอบเขตพื้นที่ที่ต้องการเก็บแคช (รัศมี 5 กิโลเมตร)
  static const double cacheRadiusKm = 5.0;
  
  // ระดับซูมที่ต้องการเก็บแคช
  static const int minZoomLevel = 10;  // ซูมออกมาก (เห็นพื้ที่กว้าง)
  static const int maxZoomLevel = 19;  // ซูมเข้าสุด (เห็นรายละเอียด)
  
  // พื้นที่พิเศษที่ต้องการเก็บแคชเพิ่มเติม
  static const List<MapArea> additionalAreas = [];
  
  /// ได้ขอบเขตหลักสำหรับมหาวิทยาลัย
  static LatLngBounds getMainBounds() {
    return LatLngBounds.fromCenter(
      center: universityCenter,
      radiusKm: cacheRadiusKm,
    );
  }
  
  /// ได้รายการขอบเขตทั้งหมดที่ต้องเก็บแคช
  static List<LatLngBounds> getAllBounds() {
    final bounds = <LatLngBounds>[getMainBounds()];
    
    for (final area in additionalAreas) {
      bounds.add(LatLngBounds.fromCenter(
        center: area.center,
        radiusKm: area.radiusKm,
      ));
    }
    
    return bounds;
  }
  
  /// คำนวณจำนวน tiles ทั้งหมดที่ต้องดาวน์โหลด
  static int calculateTotalTiles() {
    final prefetcher = MapTilePrefetcher();
    int totalTiles = 0;
    
    for (final bounds in getAllBounds()) {
      totalTiles += prefetcher.calculateTileCount(
        bounds,
        minZoomLevel,
        maxZoomLevel,
      );
    }
    
    return totalTiles;
  }
  
  /// คำนวณขนาดโดยประมาณ (KB) - ใช้ค่าเฉลี่ยที่แม่นยำกว่า
  static int estimateDownloadSizeKB() {
    const averageTileSizeKB = 15; // ค่าเฉลี่ยที่เหมาะสมกว่าสำหรับ OSM tiles
    return calculateTotalTiles() * averageTileSizeKB;
  }
  
  /// คำนวณขนาดจริงของ cache ที่มีอยู่
  static Future<double> getCurrentCacheSizeMB() async {
    final prefetcher = MapTilePrefetcher();
    final sizeBytes = await prefetcher.getCacheSize();
    return sizeBytes / (1024 * 1024); // แปลงเป็น MB
  }
  
  /// ดาวน์โหลด tiles สำหรับพื้นที่ทั้งหมด
  static Future<bool> downloadAllAreas({
    required Function(int downloaded, int total) onProgress,
    MapTilePrefetcher? prefetcher,
  }) async {
    final actualPrefetcher = prefetcher ?? MapTilePrefetcher(onProgress: onProgress);
    final allBounds = getAllBounds();
    
    try {
      for (int i = 0; i < allBounds.length; i++) {
        // ตรวจสอบการยกเลิก
        if (actualPrefetcher.isCancelled) {
          print('การดาวน์โหลดถูกยกเลิก');
          return false;
        }
        
        final bounds = allBounds[i];
        print('กำลังดาวน์โหลดพื้นที่ ${i + 1}/${allBounds.length}');
        
        final success = await actualPrefetcher.prefetchArea(
          bounds: bounds,
          minZoom: minZoomLevel,
          maxZoom: maxZoomLevel,
        );
        
        if (!success) {
          print('ไม่สามารถดาวน์โหลดพื้นที่ ${i + 1} ได้');
          return false;
        }
      }
      
      return true;
    } catch (e) {
      print('เกิดข้อผิดพลาดในการดาวน์โหลด: $e');
      return false;
    }
  }
}

class MapArea {
  final String name;
  final LatLng center;
  final double radiusKm;
  
  const MapArea({
    required this.name,
    required this.center,
    required this.radiusKm,
  });
}

// Extension สำหรับสร้าง LatLngBounds จากจุดกึ่งกลางและรัศมี
extension LatLngBoundsExtension on LatLngBounds {
  static LatLngBounds fromCenter({
    required LatLng center,
    required double radiusKm,
  }) {
    const double earthRadiusKm = 6371.0;
    
    // คำนวณ lat/lng offset จากรัศมี
    double latOffset = (radiusKm / earthRadiusKm) * (180 / 3.14159);
    double lngOffset = latOffset / (3.14159 / 180 * 6371 * 1000 / 111320);
    
    return LatLngBounds(
      north: center.latitude + latOffset,
      south: center.latitude - latOffset,
      east: center.longitude + lngOffset,
      west: center.longitude - lngOffset,
    );
  }
}