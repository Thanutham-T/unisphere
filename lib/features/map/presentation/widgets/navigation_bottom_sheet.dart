import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/logging/app_logger.dart';

class NavigationBottomSheet extends StatelessWidget {
  final String destinationName;
  final LatLng destination;
  final String distance; // Changed from double to String
  final int estimatedTimeMinutes;
  final String? phoneNumber;
  final String? website;
  final VoidCallback onStartNavigation;
  final VoidCallback onClose;

  const NavigationBottomSheet({
    super.key,
    required this.destinationName,
    required this.destination,
    required this.distance,
    required this.estimatedTimeMinutes,
    this.phoneNumber,
    this.website,
    required this.onStartNavigation,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          _buildHeader(theme),

          // Navigation options row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Walking option (selected)
                Expanded(
                  child: _buildNavigationOption(
                    context,
                    icon: Icons.directions_walk,
                    label: '$estimatedTimeMinutes นาที',
                    subtitle: 'เดินทาง',
                    isSelected: true,
                  ),
                ),
                const SizedBox(width: 8),
                // Phone option
                Expanded(
                  child: GestureDetector(
                    onTap: () => _handlePhoneCall(context),
                    child: _buildNavigationOption(
                      context,
                      icon: Icons.phone,
                      label: 'โทร',
                      subtitle: '',
                      isSelected: false,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Website option
                Expanded(
                  child: GestureDetector(
                    onTap: () => _handleWebsite(context),
                    child: _buildNavigationOption(
                      context,
                      icon: Icons.language,
                      label: 'เว็บไซต์',
                      subtitle: '',
                      isSelected: false,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Favorite option
                Expanded(
                  child: _buildNavigationOption(
                    context,
                    icon: Icons.star_border,
                    label: 'บันทึก',
                    subtitle: '',
                    isSelected: false,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Distance and status
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'จากที่ตั้ง: ',
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  distance, // Use formatted distance string directly
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'เปิด',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Start navigation button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onStartNavigation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.navigation,
                      size: 20,
                      color: colorScheme.onPrimary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'เริ่มนำทาง',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildNavigationOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isSelected 
          ? colorScheme.primaryContainer 
          : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: isSelected 
          ? Border.all(color: colorScheme.primary, width: 1)
          : null,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected 
              ? colorScheme.onPrimaryContainer 
              : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isSelected 
                ? colorScheme.onPrimaryContainer 
                : colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle.isNotEmpty) ...[
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10,
                color: isSelected 
                  ? colorScheme.onPrimaryContainer 
                  : colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  void _handlePhoneCall(BuildContext context) {
    if (phoneNumber == null || phoneNumber!.isEmpty) {
      _showNoDataDialog(context, 'เบอร์โทรศัพท์', 'ไม่มีข้อมูลเบอร์โทรศัพท์สำหรับสถานที่นี้');
      return;
    }

    _launchPhone(context, phoneNumber!);
  }

  void _handleWebsite(BuildContext context) {
    if (website == null || website!.isEmpty) {
      _showNoDataDialog(context, 'เว็บไซต์', 'ไม่มีข้อมูลเว็บไซต์สำหรับสถานที่นี้');
      return;
    }

    _launchWebsite(context, website!);
  }

  void _showNoDataDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchPhone(BuildContext context, String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      final bool canLaunch = await canLaunchUrl(phoneUri);
      if (canLaunch) {
        await launchUrl(phoneUri);
      } else {
        AppLogger.debug('Cannot launch phone dialer');
        // แสดงข้อความเตือน
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ไม่สามารถเปิดแอปโทรศัพท์ได้'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      AppLogger.error('Could not launch phone', e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('เกิดข้อผิดพลาดในการเปิดแอปโทรศัพท์'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _launchWebsite(BuildContext context, String url) async {
    final Uri webUri = Uri.parse(url);
    try {
      final bool canLaunch = await canLaunchUrl(webUri);
      if (canLaunch) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } else {
        AppLogger.debug('Cannot launch website');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ไม่สามารถเปิดเว็บไซต์ได้'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      AppLogger.error('Could not launch website', e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('เกิดข้อผิดพลาดในการเปิดเว็บไซต์'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destinationName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'คณะ • คณะวิศวกรรมศาสตร์ มหาวิทยาลัยสงขลานครินทร์',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: Icon(
              Icons.close,
              color: theme.hintColor,
            ),
          ),
        ],
      ),
    );
  }
}