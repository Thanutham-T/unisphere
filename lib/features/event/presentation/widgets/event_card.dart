import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/event.dart';
import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  void _toggleRegistration(BuildContext context) {
    // Check if event is completed
    if (event.status == 'completed') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ไม่สามารถลงทะเบียนกิจกรรมที่จบแล้วได้'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Check if event is full (and user is not already registered)
    if (event.isFull && !event.isRegistered) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('กิจกรรมนี้เต็มแล้ว ไม่สามารถลงทะเบียนได้'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'เข้าใจแล้ว',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
      return;
    }

    if (event.isRegistered) {
      // Show confirmation dialog for unregistration
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ยกเลิกการลงทะเบียน'),
          content: Text('คุณต้องการยกเลิกการลงทะเบียน "${event.title}" หรือไม่?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<EventBloc>().add(UnregisterFromEvent(event.id.toString()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('ยกเลิกลงทะเบียน'),
            ),
          ],
        ),
      );
    } else {
      // Show confirmation dialog for registration with capacity info
      String confirmationText = 'คุณต้องการลงทะเบียน "${event.title}" หรือไม่?';
      if (event.hasCapacityLimit && event.availableSpots != null) {
        if (event.isNearlyFull) {
          confirmationText += '\n\nเหลือที่นั่งอีก ${event.availableSpots} ที่เท่านั้น!';
        } else {
          confirmationText += '\n\nมีที่นั่งว่างอีก ${event.availableSpots} ที่';
        }
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ลงทะเบียนกิจกรรม'),
          content: Text(confirmationText),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<EventBloc>().add(RegisterForEvent(event.id.toString()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E3192),
                foregroundColor: Colors.white,
              ),
              child: const Text('ลงทะเบียน'),
            ),
          ],
        ),
      );
    }
  }

  Color _getButtonColor(bool isCompleted) {
    if (isCompleted) {
      return Colors.grey;
    } else if (event.isFull && !event.isRegistered) {
      return Colors.red.shade400; // Full event
    } else if (event.isRegistered) {
      return Colors.green.shade600;
    } else {
      return const Color(0xFF2E3192); // Primary color
    }
  }

  IconData _getButtonIcon(bool isCompleted) {
    if (isCompleted) {
      return Icons.event_busy;
    } else if (event.isFull && !event.isRegistered) {
      return Icons.block; // Full event
    } else if (event.isRegistered) {
      return Icons.check;
    } else {
      return Icons.add;
    }
  }

  String _getButtonText(bool isCompleted) {
    if (isCompleted) {
      return 'จบแล้ว';
    } else if (event.isFull && !event.isRegistered) {
      return 'เต็มแล้ว'; // Full event
    } else if (event.isRegistered) {
      return 'ลงทะเบียนแล้ว';
    } else {
      return 'ลงทะเบียน';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy', 'th');
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: isDarkMode ? 8 : 4,
        shadowColor: isDarkMode 
            ? Colors.black.withValues(alpha: 0.3) 
            : Colors.black.withValues(alpha: 0.1),
        color: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Event Image
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  color: isDarkMode 
                      ? Colors.grey[800] 
                      : Colors.grey[200],
                ),
                child: Stack(
                  children: [
                    // Event Image or Placeholder
                    if (event.imageUrl != null && event.imageUrl!.isNotEmpty)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: event.imageUrl!.startsWith('file://')
                            ? Image.file(
                                File(event.imageUrl!.substring(7)),
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildPlaceholder(isDarkMode);
                                },
                              )
                            : Image.network(
                                event.imageUrl!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildPlaceholder(isDarkMode);
                                },
                              ),
                      )
                    else
                      _buildPlaceholder(isDarkMode),
                    
                    // Registration status badge
                    if (event.isRegistered)
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade600,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'ลงทะเบียนแล้ว',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    // Category badge
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(event.category),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          event.category ?? 'อื่นๆ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      event.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Description
                    if (event.description?.isNotEmpty == true) ...[
                      Text(
                        event.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                    ],
                    
                    // Date and Location
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          dateFormat.format(event.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const Spacer(),
                        if (event.location?.isNotEmpty == true) ...[
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              event.location!,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // 🆕 Capacity indicator (if event has capacity limit)
                    if (event.hasCapacityLimit) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: event.isFull 
                            ? (isDarkMode ? Colors.red[900] : Colors.red[50])
                            : event.isNearlyFull 
                              ? (isDarkMode ? Colors.orange[900] : Colors.orange[50])
                              : (isDarkMode ? Colors.green[900] : Colors.green[50]),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: event.isFull 
                              ? Colors.red.withOpacity(0.3)
                              : event.isNearlyFull 
                                ? Colors.orange.withOpacity(0.3)
                                : Colors.green.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            // Progress bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: event.capacityPercentage,
                                backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  event.isFull 
                                    ? Colors.red 
                                    : event.isNearlyFull 
                                      ? Colors.orange 
                                      : Colors.green,
                                ),
                                minHeight: 4,
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Capacity text
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${event.registrationCount}/${event.maxCapacity}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: event.isFull 
                                      ? (isDarkMode ? Colors.red[300] : Colors.red[700])
                                      : event.isNearlyFull 
                                        ? (isDarkMode ? Colors.orange[300] : Colors.orange[700])
                                        : (isDarkMode ? Colors.green[300] : Colors.green[700]),
                                  ),
                                ),
                                if (event.availableSpots != null && !event.isFull)
                                  Text(
                                    'เหลือ ${event.availableSpots}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: event.isNearlyFull 
                                        ? (isDarkMode ? Colors.orange[400] : Colors.orange[600])
                                        : (isDarkMode ? Colors.green[400] : Colors.green[600]),
                                    ),
                                  ),
                                if (event.isFull)
                                  Text(
                                    'เต็มแล้ว',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode ? Colors.red[400] : Colors.red[600],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    
                    // Registration info and button row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Registration count info
                        Row(
                          children: [
                            Icon(
                              Icons.group,
                              size: 16,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              event.hasCapacityLimit 
                                ? '${event.registrationCount} คนลงทะเบียน'
                                : '${event.registrationCount} คนลงทะเบียน (ไม่จำกัด)',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                        
                        // Quick registration button
                        BlocBuilder<EventBloc, EventState>(
                          builder: (context, state) {
                            final isLoading = state is EventActionLoading && 
                                state.eventId == event.id.toString();
                            final isCompleted = event.status == 'completed';
                            final isFullAndNotRegistered = event.isFull && !event.isRegistered;
                            
                            return SizedBox(
                              height: 32,
                              child: ElevatedButton(
                                onPressed: (isLoading || isCompleted || isFullAndNotRegistered) 
                                  ? null 
                                  : () => _toggleRegistration(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _getButtonColor(isCompleted),
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: Colors.grey[400],
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  minimumSize: const Size(80, 32),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            _getButtonIcon(isCompleted),
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            _getButtonText(isCompleted),
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'วิชาการ':
        return Colors.blue;
      case 'กีฬา':
      case 'sport':
        return Colors.green;
      case 'ศิลปกรรม':
        return Colors.purple;
      case 'workshop':
        return Colors.orange;
      case 'career':
        return Colors.indigo;
      case 'อื่นๆ':
      default:
        return Colors.grey;
    }
  }

  Widget _buildPlaceholder(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 48,
            color: isDarkMode 
                ? Colors.grey[600] 
                : Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'ยังไม่มีรูปภาพ',
            style: TextStyle(
              color: isDarkMode 
                  ? Colors.grey[600] 
                  : Colors.grey[400],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}