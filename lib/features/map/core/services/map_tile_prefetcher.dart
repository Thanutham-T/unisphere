import 'dart:math';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/logging/app_logger.dart';

class MapTilePrefetcher {
  static const String _tileUrlTemplate = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const int _maxConcurrentDownloads = 5;
  
  // Progress callback
  final void Function(int downloaded, int total)? onProgress;
  
  // Control flags
  bool _isPaused = false;
  bool _isCancelled = false;
  
  MapTilePrefetcher({this.onProgress});

  // Control methods
  void pause() => _isPaused = true;
  void resume() => _isPaused = false;
  void cancel() => _isCancelled = true;
  bool get isPaused => _isPaused;
  bool get isCancelled => _isCancelled;

  /// คำนวณจำนวน tiles ที่ต้องดาวน์โหลดสำหรับพื้นที่และซูมระดับที่กำหนด
  int calculateTileCount(LatLngBounds bounds, int minZoom, int maxZoom) {
    int totalTiles = 0;
    
    for (int zoom = minZoom; zoom <= maxZoom; zoom++) {
      final topLeft = _latLngToTileCoords(bounds.north, bounds.west, zoom);
      final bottomRight = _latLngToTileCoords(bounds.south, bounds.east, zoom);
      
      final tilesX = (bottomRight.x - topLeft.x + 1).abs();
      final tilesY = (bottomRight.y - topLeft.y + 1).abs();
      
      totalTiles += tilesX * tilesY;
    }
    
    return totalTiles;
  }

  /// ดาวน์โหลด tiles สำหรับพื้นที่และซูมระดับที่กำหนด
  Future<bool> prefetchArea({
    required LatLngBounds bounds,
    required int minZoom,
    required int maxZoom,
  }) async {
    try {
      // รีเซ็ตสถิติ
      _totalDownloadedBytes = 0;
      _skippedTiles = 0;
      _failedTiles = 0;
      
      final totalTiles = calculateTileCount(bounds, minZoom, maxZoom);
      int processedTiles = 0;
      
      AppLogger.debug('เริ่มดาวน์โหลด $totalTiles tiles สำหรับพื้นที่ออฟไลน์');
      
      // สร้าง semaphore เพื่อจำกัดการดาวน์โหลดพร้อมกัน
      final semaphore = <Future>[];
      
      for (int zoom = minZoom; zoom <= maxZoom; zoom++) {
        if (_isCancelled) {
          _printSummary(processedTiles, totalTiles);
          return false;
        }
        
        final topLeft = _latLngToTileCoords(bounds.north, bounds.west, zoom);
        final bottomRight = _latLngToTileCoords(bounds.south, bounds.east, zoom);
        
        for (int x = topLeft.x; x <= bottomRight.x; x++) {
          for (int y = topLeft.y; y <= bottomRight.y; y++) {
            // ตรวจสอบการยกเลิก
            if (_isCancelled) {
              _printSummary(processedTiles, totalTiles);
              return false;
            }
            
            // รอถ้าถูกหยุดชั่วคราว
            while (_isPaused && !_isCancelled) {
              await Future.delayed(const Duration(milliseconds: 100));
            }
            
            // รอให้มี slot ว่างสำหรับดาวน์โหลด
            if (semaphore.length >= _maxConcurrentDownloads) {
              await Future.any(semaphore);
              semaphore.clear(); // ล้าง futures ที่เสร็จแล้ว
            }
            
            // เริ่มดาวน์โหลด tile
            final downloadFuture = _downloadTile(x, y, zoom).then((_) {
              processedTiles++;
              if (!_isCancelled) {
                onProgress?.call(processedTiles, totalTiles);
              }
            }).catchError((error) {
              // จัดการ error แต่ยังให้ดำเนินการต่อ
              processedTiles++;
              if (!_isCancelled) {
                onProgress?.call(processedTiles, totalTiles);
              }
            });
            
            semaphore.add(downloadFuture);
          }
        }
      }
      
      // รอให้ดาวน์โหลดที่เหลือเสร็จสิ้น
      await Future.wait(semaphore);
      
      _printSummary(processedTiles, totalTiles);
      return _failedTiles < (totalTiles * 0.1); // สำเร็จถ้า failed น้อยกว่า 10%
      
    } catch (e) {
      AppLogger.debug('เกิดข้อผิดพลาดในการดาวน์โหลด: $e');
      return false;
    }
  }
  
  /// พิมพ์สรุปผลการดาวน์โหลด
  void _printSummary(int processed, int total) {
    final successfulDownloads = processed - _skippedTiles - _failedTiles;
    AppLogger.debug('--- สรุปการดาวน์โหลด ---');
    AppLogger.debug('Tiles ทั้งหมด: $total');
    AppLogger.debug('ดาวน์โหลดสำเร็จ: $successfulDownloads');
    AppLogger.debug('ข้ามไป (มีอยู่แล้ว): $_skippedTiles');
    AppLogger.debug('ล้มเหลว: $_failedTiles');
    AppLogger.debug('ขนาดรวม: ${totalDownloadedMB.toStringAsFixed(2)} MB');
    AppLogger.debug('------------------------');
  }

  // สถิติการดาวน์โหลด
  int _totalDownloadedBytes = 0;
  int _skippedTiles = 0;
  int _failedTiles = 0;
  
  // Getters สำหรับสถิติ
  int get totalDownloadedBytes => _totalDownloadedBytes;
  int get skippedTiles => _skippedTiles;
  int get failedTiles => _failedTiles;
  double get totalDownloadedMB => _totalDownloadedBytes / (1024 * 1024);

  /// ดาวน์โหลด tile เดียว พร้อม retry mechanism
  Future<void> _downloadTile(int x, int y, int zoom, {int retryCount = 0}) async {
    const maxRetries = 3;
    const retryDelays = [
      Duration(milliseconds: 500),
      Duration(seconds: 1),
      Duration(seconds: 2),
    ];
    
    try {
      final url = _tileUrlTemplate
          .replaceAll('{z}', zoom.toString())
          .replaceAll('{x}', x.toString())
          .replaceAll('{y}', y.toString());
      
      // ตรวจสอบว่ามี tile นี้ในแคชแล้วหรือไม่
      final file = await _getTileFile(x, y, zoom);
      if (await file.exists()) {
        _skippedTiles++;
        return; // มีแล้ว ข้าม
      }
      
      // สร้าง directory ถ้ายังไม่มี
      await file.parent.create(recursive: true);
      
      // ดาวน์โหลด tile
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'unisphere-app/1.0 (Flutter Map Cache)'
        },
      ).timeout(const Duration(seconds: 30)); // เพิ่ม timeout
      
      if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
        await file.writeAsBytes(response.bodyBytes);
        _totalDownloadedBytes += response.bodyBytes.length;
        
        // ลด failed count ถ้าเคย retry สำเร็จ
        if (retryCount > 0) {
          _failedTiles = (_failedTiles - retryCount).clamp(0, _failedTiles);
        }
        
        if (retryCount > 0) {
          AppLogger.debug('ดาวน์โหลด tile $x,$y,$zoom สำเร็จหลังจาก retry $retryCount ครั้ง (${response.bodyBytes.length} bytes)');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
      
    } catch (e) {
      if (retryCount < maxRetries && !_isCancelled) {
        // พยายามใหม่
        await Future.delayed(retryDelays[retryCount]);
        if (!_isCancelled) {
          AppLogger.debug('พยายามดาวน์โหลด tile $x,$y,$zoom ใหม่ ครั้งที่ ${retryCount + 1}');
          return _downloadTile(x, y, zoom, retryCount: retryCount + 1);
        }
      }
      
      // ล้มเหลวสุดท้าย
      _failedTiles++;
      AppLogger.debug('ไม่สามารถดาวน์โหลด tile $x,$y,$zoom หลังจากพยายาม ${retryCount + 1} ครั้ง: $e');
    }
  }

  /// แปลง LatLng เป็น tile coordinates
  TileCoordinates _latLngToTileCoords(double lat, double lng, int zoom) {
    final latRad = lat * (pi / 180.0);
    final n = pow(2.0, zoom);
    
    final x = ((lng + 180.0) / 360.0 * n).floor();
    final y = ((1.0 - _asinh(tan(latRad)) / pi) / 2.0 * n).floor();
    
    return TileCoordinates(x, y);
  }

  /// ได้ path ของ tile file
  Future<File> _getTileFile(int x, int y, int zoom) async {
    final directory = await getApplicationDocumentsDirectory();
    final tilePath = '${directory.path}/map_cache/$zoom/$x/$y.png';
    return File(tilePath);
  }

  /// คำนวณ inverse hyperbolic sine
  double _asinh(double x) {
    return log(x + sqrt(x * x + 1));
  }

  /// ลบแคช tiles ทั้งหมด
  Future<void> clearCache() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final cacheDir = Directory('${directory.path}/map_cache');
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
      }
    } catch (e) {
      AppLogger.debug('ไม่สามารถลบแคช: $e');
    }
  }

  /// ตรวจสอบขนาดแคช
  Future<int> getCacheSize() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final cacheDir = Directory('${directory.path}/map_cache');
      
      if (!await cacheDir.exists()) return 0;
      
      int totalSize = 0;
      await for (final file in cacheDir.list(recursive: true)) {
        if (file is File) {
          final stat = await file.stat();
          totalSize += stat.size;
        }
      }
      
      return totalSize;
    } catch (e) {
      return 0;
    }
  }
}

class TileCoordinates {
  final int x;
  final int y;
  
  TileCoordinates(this.x, this.y);
}

class LatLngBounds {
  final double north;
  final double south;
  final double east;
  final double west;
  
  LatLngBounds({
    required this.north,
    required this.south,
    required this.east,
    required this.west,
  });
  
  /// สร้าง bounds สำหรับพื้นที่รอบๆ จุดกลาง
  factory LatLngBounds.fromCenter({
    required LatLng center,
    required double radiusKm,
  }) {
    // คำนวณขอบเขตจากรัศมี (approximate)
    final latOffset = radiusKm / 111.0; // 1 degree ≈ 111 km
    final lngOffset = radiusKm / (111.0 * cos(center.latitude * pi / 180));
    
    return LatLngBounds(
      north: center.latitude + latOffset,
      south: center.latitude - latOffset,
      east: center.longitude + lngOffset,
      west: center.longitude - lngOffset,
    );
  }
}