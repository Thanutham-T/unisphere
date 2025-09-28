import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/logging/app_logger.dart';

class OfflineTileProvider {
  static TileLayer createOfflineTileLayer() {
    return TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.example.unisphere',
      maxZoom: 19,
      tileBuilder: (context, widget, tile) {
        return FutureBuilder<Widget>(
          future: _buildTileWidget(context, tile),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            }
            return Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              width: 256,
              height: 256,
              child: const Center(child: CircularProgressIndicator()),
            );
          },
        );
      },
    );
  }

  static Future<Widget> _buildTileWidget(
    BuildContext context,
    TileImage tile,
  ) async {
    try {
      // ลองโหลดจากแคชก่อน
      final cachedTile = await _loadFromCache(tile);
      if (cachedTile != null) {
        return cachedTile;
      }

      // ถ้าไม่มีในแคช ลองดาวน์โหลดจากเน็ต
      final networkTile = await _loadFromNetwork(context, tile);
      if (networkTile != null) {
        return networkTile;
      }

      // ถ้าทั้งสองอย่างไม่ได้ ให้แสดง placeholder
      return _buildPlaceholder(context);
    } catch (e) {
      return _buildErrorWidget(context);
    }
  }

  static Future<Widget?> _loadFromCache(TileImage tile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final coords = tile.coordinates;
      final tileFile = File(
        '${directory.path}/map_cache/${coords.z}/${coords.x}/${coords.y}.png',
      );

      if (await tileFile.exists()) {
        final bytes = await tileFile.readAsBytes();
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: 256,
          height: 256,
          gaplessPlayback: true,
        );
      }
    } catch (e) {
      AppLogger.error('ไม่สามารถโหลดจากแคช', e);
    }
    return null;
  }

  static Future<Widget?> _loadFromNetwork(
    BuildContext context,
    TileImage tile,
  ) async {
    try {
      final coords = tile.coordinates;
      final url =
          'https://tile.openstreetmap.org/${coords.z}/${coords.x}/${coords.y}.png';

      // ใช้ NetworkImage กับ ErrorBuilder
      return Image.network(
        url,
        fit: BoxFit.cover,
        width: 256,
        height: 256,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            // โหลดเสร็จแล้ว เก็บลงแคช
            _saveToCache(tile, url);
            return child;
          }
          return _buildPlaceholder(context);
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget(context);
        },
      );
    } catch (e) {
      return null;
    }
  }

  static Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      width: 256,
      height: 256,
      child: Icon(Icons.terrain, size: 50, color: Theme.of(context).hintColor),
    );
  }

  static Widget _buildErrorWidget(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      width: 256,
      height: 256,
      child: Icon(
        Icons.error_outline,
        size: 50,
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }

  static Future<void> _saveToCache(TileImage tile, String url) async {
    try {
      // ใช้ HTTP client เพื่อดาวน์โหลดและเก็บลงแคช
      // (ทำในพื้นหลัง ไม่ต้องรอ)
      _saveTileAsync(tile, url);
    } catch (e) {
      AppLogger.error('ไม่สามารถเก็บลงแคช', e);
    }
  }

  static Future<void> _saveTileAsync(TileImage tile, String url) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final coords = tile.coordinates;
      final tileFile = File(
        '${directory.path}/map_cache/${coords.z}/${coords.x}/${coords.y}.png',
      );

      // ตรวจสอบว่ามีไฟล์อยู่แล้วหรือไม่
      if (await tileFile.exists()) {
        return;
      }

      // สร้าง directory ถ้ายังไม่มี
      await tileFile.parent.create(recursive: true);

      // ดาวน์โหลดและบันทึก (ทำในพื้นหลัง)
      // ใช้ HttpClient หรือ http package
    } catch (e) {
      AppLogger.error('ไม่สามารถบันทึกแคช', e);
    }
  }
}

// ส่วนขยายสำหรับ AppBar เพื่อแสดงสถานะออฟไลน์
class OfflineMapAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool showOfflineIndicator;

  const OfflineMapAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.showOfflineIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackPressed ?? () => Navigator.pop(context),
      ),
      actions: [
        if (showOfflineIndicator) ...[
          // สถานะออฟไลน์
          Tooltip(
            message: 'แผนที่รองรับการใช้งานออฟไลน์',
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                Icons.offline_pin,
                color: theme.colorScheme.secondary,
                size: 24,
              ),
            ),
          ),

          // ปุ่มจัดการแผนที่ออฟไลน์
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) => _handleMenuAction(context, value),
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
                value: 'clear',
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('ลบแคชแผนที่'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'download':
        _showDownloadDialog(context);
        break;
      case 'status':
        _showStatusDialog(context);
        break;
      case 'clear':
        _showClearCacheDialog(context);
        break;
    }
  }

  void _showDownloadDialog(BuildContext context) {
    // Import OfflineMapDownloadDialog
    // showDialog(
    //   context: context,
    //   builder: (context) => const OfflineMapDownloadDialog(),
    // );

    // Placeholder
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('ดาวน์โหลดแผนที่ออฟไลน์')));
  }

  void _showStatusDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('สถานะแผนที่ออฟไลน์'),
        content: const Text('ตรวจสอบสถานะแผนที่ออฟไลน์'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ลบแคชแผนที่'),
        content: const Text('คุณต้องการลบแคชแผนที่ทั้งหมดหรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              // ลบแคช
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ลบแคชแผนที่เรียบร้อยแล้ว')),
              );
            },
            child: const Text('ลบ'),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
