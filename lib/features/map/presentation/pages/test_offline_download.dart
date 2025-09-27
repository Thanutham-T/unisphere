import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../core/services/map_tile_prefetcher.dart';

class TestOfflineDownload extends StatefulWidget {
  const TestOfflineDownload({super.key});

  @override
  State<TestOfflineDownload> createState() => _TestOfflineDownloadState();
}

class _TestOfflineDownloadState extends State<TestOfflineDownload> {
  String _status = 'พร้อมทดสอบ';
  double _progress = 0.0;
  bool _isDownloading = false;
  bool _mounted = true;
  MapTilePrefetcher? _prefetcher;

  @override
  void dispose() {
    _mounted = false;
    if (_prefetcher != null) {
      _prefetcher!.cancel();
      _prefetcher = null;
    }
    super.dispose();
  }

  Future<void> _testSmallDownload() async {
    if (!_mounted) return;

    setState(() {
      _isDownloading = true;
      _status = 'เริ่มทดสอบดาวน์โหลด...';
      _progress = 0.0;
    });

    try {
      _prefetcher = MapTilePrefetcher(
        onProgress: (downloaded, total) {
          if (!_mounted || !mounted) return;

          Future.microtask(() {
            if (mounted && _mounted) {
              setState(() {
                _progress = downloaded / total;
                _status = 'ดาวน์โหลด $downloaded/$total tiles';
              });
            }
          });
        },
      );

      // ทดสอบด้วยพื้นที่เล็กๆ (มหาวิทยาลัย)
      const center = LatLng(7.0069451, 100.5007147);
      const radiusKm = 0.5;
      const double earthRadiusKm = 6371.0;

      // คำนวณ lat/lng offset จากรัศมี
      double latOffset = (radiusKm / earthRadiusKm) * (180 / 3.14159);
      double lngOffset = latOffset / (3.14159 / 180 * 6371 * 1000 / 111320);

      final testBounds = LatLngBounds(
        north: center.latitude + latOffset,
        south: center.latitude - latOffset,
        east: center.longitude + lngOffset,
        west: center.longitude - lngOffset,
      );

      final success = await _prefetcher!.prefetchArea(
        bounds: testBounds,
        minZoom: 15,
        maxZoom: 16, // เฉพาะ 2 ระดับซูม
      );

      if (_mounted && mounted) {
        Future.microtask(() {
          if (mounted && _mounted) {
            setState(() {
              _isDownloading = false;
              _status = success ? 'ทดสอบสำเร็จ!' : 'ทดสอบล้มเหลว';
              _progress = success ? 1.0 : 0.0;
            });
          }
        });
      }
    } catch (e) {
      if (_mounted && mounted) {
        Future.microtask(() {
          if (mounted && _mounted) {
            setState(() {
              _isDownloading = false;
              _status = 'เกิดข้อผิดพลาด: $e';
              _progress = 0.0;
            });
          }
        });
      }
    }
  }

  Future<void> _checkCacheStatus() async {
    try {
      final prefetcher = MapTilePrefetcher();
      final cacheSize = await prefetcher.getCacheSize();
      final cacheSizeMB = (cacheSize / 1024 / 1024).toStringAsFixed(2);

      if (_mounted && mounted) {
        Future.microtask(() {
          if (mounted && _mounted) {
            setState(() {
              _status = 'แคชขนาด: ${cacheSizeMB}MB';
            });
          }
        });
      }
    } catch (e) {
      if (_mounted && mounted) {
        Future.microtask(() {
          if (mounted && _mounted) {
            setState(() {
              _status = 'ไม่สามารถตรวจสอบแคชได้: $e';
            });
          }
        });
      }
    }
  }

  Future<void> _clearCache() async {
    try {
      final prefetcher = MapTilePrefetcher();
      await prefetcher.clearCache();

      if (_mounted && mounted) {
        Future.microtask(() {
          if (mounted && _mounted) {
            setState(() {
              _status = 'ล้างแคชเรียบร้อย';
              _progress = 0.0;
            });
          }
        });
      }
    } catch (e) {
      if (_mounted && mounted) {
        Future.microtask(() {
          if (mounted && _mounted) {
            setState(() {
              _status = 'ไม่สามารถล้างแคชได้: $e';
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ทดสอบการดาวน์โหลดออฟไลน์'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('สถานะ: $_status', style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(_progress * 100).toStringAsFixed(1)}%',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _isDownloading ? null : _testSmallDownload,
                  icon: const Icon(Icons.download),
                  label: const Text('ทดสอบดาวน์โหลด'),
                ),
                ElevatedButton.icon(
                  onPressed: _checkCacheStatus,
                  icon: const Icon(Icons.info),
                  label: const Text('ตรวจสอบแคช'),
                ),
                ElevatedButton.icon(
                  onPressed: _clearCache,
                  icon: const Icon(Icons.clear),
                  label: const Text('ล้างแคช'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('คำแนะนำ:', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    const Text('• ทดสอบดาวน์โหลดพื้นที่เล็กๆ ก่อน'),
                    const Text('• ตรวจสอบ Console สำหรับ logs'),
                    const Text('• ตรวจสอบขนาดแคชหลังดาวน์โหลด'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
