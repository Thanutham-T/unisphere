import 'package:flutter/material.dart';
import '../../core/config/offline_map_config.dart';
import '../../core/services/map_tile_prefetcher.dart';

class OfflineMapDownloadDialog extends StatefulWidget {
  const OfflineMapDownloadDialog({super.key});

  @override
  State<OfflineMapDownloadDialog> createState() => _OfflineMapDownloadDialogState();
}

class _OfflineMapDownloadDialogState extends State<OfflineMapDownloadDialog> {
  bool _isDownloading = false;
  bool _isPaused = false;
  bool _isCancelled = false;
  int _totalTiles = 0;
  double _progress = 0.0;
  String _statusText = '';
  
  // สำหรับควบคุมการดาวน์โหลด
  MapTilePrefetcher? _prefetcher;
  bool _mounted = true;

  @override
  void initState() {
    super.initState();
    _totalTiles = OfflineMapConfig.calculateTotalTiles();
    final estimatedSizeMB = (OfflineMapConfig.estimateDownloadSizeKB() / 1024).round();
    _statusText = 'พร้อมดาวน์โหลด $_totalTiles tiles (ประมาณ ${estimatedSizeMB}MB)';
    _checkExistingCache();
  }
  
  Future<void> _checkExistingCache() async {
    final currentCacheMB = await OfflineMapConfig.getCurrentCacheSizeMB();
    final estimatedSizeMB = (OfflineMapConfig.estimateDownloadSizeKB() / 1024).round();
    if (_mounted && currentCacheMB > 0) {
      setState(() {
        _statusText = 'พร้อมดาวน์โหลด $_totalTiles tiles (ประมาณ ${estimatedSizeMB}MB)\nมีแคชอยู่แล้ว: ${currentCacheMB.toStringAsFixed(1)}MB';
      });
    }
  }

  @override
  void dispose() {
    _mounted = false;
    // ยกเลิกการดาวน์โหลดอย่างทันที
    if (_prefetcher != null) {
      _prefetcher!.cancel();
      _prefetcher = null;
    }
    _isCancelled = true;
    _isDownloading = false;
    super.dispose();
  }

  Future<void> _startDownload() async {
    if (!_mounted) return;
    
    setState(() {
      _isDownloading = true;
      _isPaused = false;
      _isCancelled = false;
      _statusText = 'กำลังเริ่มดาวน์โหลด...';
    });

    _prefetcher = MapTilePrefetcher(
      onProgress: (downloaded, total) {
        // ป้องกันการ callback หลัง dispose
        if (!_mounted || _isCancelled || !mounted) return;
        
        if (_isPaused) {
          // ถ้าหยุดชั่วคราว ไม่อัพเดท progress
          return;
        }
        
        // ใช้ Future.microtask เพื่อให้แน่ใจว่า widget ยังอยู่
        Future.microtask(() {
          if (mounted && _mounted && !_isCancelled) {
            setState(() {
              _totalTiles = total;
              _progress = downloaded / total;
              final downloadedMB = _prefetcher?.totalDownloadedMB ?? 0;
              final skipped = _prefetcher?.skippedTiles ?? 0;
              final failed = _prefetcher?.failedTiles ?? 0;
              _statusText = 'ดาวน์โหลดแล้ว $downloaded/$total tiles\n'
                          'ขนาด: ${downloadedMB.toStringAsFixed(1)}MB\n'
                          'ข้าม: $skipped, ล้มเหลว: $failed';
            });
          }
        });
      },
    );

    try {
      final success = await OfflineMapConfig.downloadAllAreas(
        prefetcher: _prefetcher,
        onProgress: (downloaded, total) {
          // Progress จะถูกจัดการใน prefetcher แล้ว
        },
      );

      if (_mounted && mounted && !_isCancelled) {
        Future.microtask(() {
          if (mounted && _mounted && !_isCancelled) {
            setState(() {
              _isDownloading = false;
              if (success) {
                _statusText = 'ดาวน์โหลดเสร็จสิ้น! พร้อมใช้งานออฟไลน์';
                _progress = 1.0;
              } else {
                _statusText = 'เกิดข้อผิดพลาดในการดาวน์โหลด';
              }
            });
          }
        });

        if (success) {
          // ปิด dialog หลังจาก 2 วินาที
          await Future.delayed(const Duration(seconds: 2));
          if (mounted && _mounted) {
            Navigator.of(context).pop(true);
          }
        }
      }
    } catch (e) {
      if (_mounted && mounted) {
        Future.microtask(() {
          if (mounted && _mounted) {
            setState(() {
              _isDownloading = false;
              _statusText = 'เกิดข้อผิดพลาด: $e';
            });
          }
        });
      }
    }
  }

  void _pauseDownload() {
    if (_isDownloading && !_isPaused && _prefetcher != null && mounted && _mounted) {
      _prefetcher!.pause();
      Future.microtask(() {
        if (mounted && _mounted) {
          setState(() {
            _isPaused = true;
            _statusText = 'หยุดชั่วคราว - กด Resume เพื่อดำเนินการต่อ';
          });
        }
      });
    }
  }

  void _resumeDownload() {
    if (_isDownloading && _isPaused && _prefetcher != null && mounted && _mounted) {
      _prefetcher!.resume();
      Future.microtask(() {
        if (mounted && _mounted) {
          setState(() {
            _isPaused = false;
            _statusText = 'ดำเนินการต่อ...';
          });
        }
      });
    }
  }

  void _cancelDownload() {
    if (_prefetcher != null) {
      _prefetcher!.cancel();
      _prefetcher = null;
    }
    
    if (mounted && _mounted) {
      Future.microtask(() {
        if (mounted && _mounted) {
          setState(() {
            _isCancelled = true;
            _isDownloading = false;
            _isPaused = false;
            _statusText = 'ยกเลิกการดาวน์โหลดแล้ว';
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      title: Row(
        children: [
          Icon(
            Icons.offline_pin,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            'ดาวน์โหลดแผนที่ออฟไลน์',
            style: theme.textTheme.titleLarge,
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ดาวน์โหลดแผนที่เพื่อใช้งานออฟไลน์',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            
            // ข้อมูลการดาวน์โหลด
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'พื้นที่ที่จะดาวน์โหลด:',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '• มหาวิทยาลัยและบริเวณโดยรอบ (รัศมี ${OfflineMapConfig.cacheRadiusKm} กม.)',
                    style: theme.textTheme.bodySmall,
                  ),
                  for (final area in OfflineMapConfig.additionalAreas)
                    Text(
                      '• ${area.name} (รัศมี ${area.radiusKm} กม.)',
                      style: theme.textTheme.bodySmall,
                    ),
                  const SizedBox(height: 8),
                  Text(
                    'ระดับซูม: ${OfflineMapConfig.minZoomLevel}-${OfflineMapConfig.maxZoomLevel}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Progress bar
            if (_isDownloading || _progress > 0) ...[
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
              const SizedBox(height: 8),
              Text(
                '${(_progress * 100).toStringAsFixed(1)}%',
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
            
            // Status text
            Text(
              _statusText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: _isDownloading 
                    ? colorScheme.primary 
                    : colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (!_isDownloading) ...[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'ปิด',
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _startDownload,
            icon: const Icon(Icons.download),
            label: const Text('เริ่มดาวน์โหลด'),
          ),
        ] else ...[
          // ปุ่มควบคุมระหว่างดาวน์โหลด
          if (_isPaused) ...[
            TextButton.icon(
              onPressed: _resumeDownload,
              icon: const Icon(Icons.play_arrow),
              label: const Text('ดำเนินการต่อ'),
            ),
          ] else ...[
            TextButton.icon(
              onPressed: _pauseDownload,
              icon: const Icon(Icons.pause),
              label: const Text('หยุดชั่วคราว'),
            ),
          ],
          TextButton.icon(
            onPressed: _cancelDownload,
            icon: const Icon(Icons.stop),
            label: Text(
              'ยกเลิก',
              style: TextStyle(color: colorScheme.error),
            ),
          ),
        ],
      ],
    );
  }
}

// Widget สำหรับแสดงสถานะแคช
class OfflineMapStatus extends StatefulWidget {
  const OfflineMapStatus({super.key});

  @override
  State<OfflineMapStatus> createState() => _OfflineMapStatusState();
}

class _OfflineMapStatusState extends State<OfflineMapStatus> {
  int _cacheSize = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCacheSize();
  }

  Future<void> _loadCacheSize() async {
    // ใช้ MapTilePrefetcher เพื่อตรวจสอบขนาดแคช
    // final prefetcher = MapTilePrefetcher();
    // final size = await prefetcher.getCacheSize();
    
    setState(() {
      _cacheSize = 0; // placeholder
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return const CircularProgressIndicator();
    }

    final cacheSizeMB = (_cacheSize / 1024 / 1024).toStringAsFixed(1);
    final hasCache = _cacheSize > 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hasCache ? colorScheme.primaryContainer : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            hasCache ? Icons.offline_pin : Icons.cloud_download,
            color: hasCache ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasCache ? 'พร้อมใช้งานออฟไลน์' : 'ยังไม่มีแผนที่ออฟไลน์',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: hasCache ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
                  ),
                ),
                if (hasCache)
                  Text(
                    'ขนาดแคช: ${cacheSizeMB}MB',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}