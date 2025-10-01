import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';
import '../../domain/entities/event.dart';
import 'add_edit_event_screen.dart';

class EventManagementScreen extends StatelessWidget {
  const EventManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.instance<EventBloc>(),
      child: const _EventManagementContent(),
    );
  }
}

class _EventManagementContent extends StatelessWidget {
  const _EventManagementContent();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'จัดการกิจกรรม',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : const Color(0xFF2E3192),
          ),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : const Color(0xFF2E3192),
        ),
      ),
      body: BlocListener<EventBloc, EventState>(
        listener: (context, state) {
          if (state is EventActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // No need to manually refresh - EventBloc auto-refreshes now
          } else if (state is EventError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<EventBloc, EventState>(
          builder: (context, state) {
          if (state is EventLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (state is EventActionLoading) {
            // Show loading overlay for CRUD operations but keep existing UI
            return Stack(
              children: [
                // Show the current events list (if available from previous state)
                BlocBuilder<EventBloc, EventState>(
                  buildWhen: (previous, current) => current is EventLoaded,
                  builder: (context, previousState) {
                    if (previousState is EventLoaded) {
                      return _buildEventManagementList(previousState.events, Theme.of(context).brightness == Brightness.dark, context);
                    }
                    return const SizedBox.shrink();
                  },
                ),
                // Loading overlay
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            );
          }
          
          if (state is EventError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'เกิดข้อผิดพลาด',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<EventBloc>().add(LoadEvents());
                    },
                    child: const Text('ลองใหม่'),
                  ),
                ],
              ),
            );
          }
          
          if (state is EventLoaded) {
            if (state.events.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_note,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'ยังไม่มีกิจกรรม',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'เริ่มสร้างกิจกรรมแรกของคุณ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }
            
            return _buildEventManagementList(state.events, isDarkMode, context);
          }
          
          return const SizedBox.shrink();
        },
      ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditEventScreen(),
            ),
          );
          
          // Refresh events if something was created/updated
          if (result == true) {
            context.read<EventBloc>().add(LoadEvents());
          }
        },
        backgroundColor: const Color(0xFF2E3192),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('เพิ่มกิจกรรม'),
      ),
    );
  }

  Widget _buildEventManagementList(List<Event> events, bool isDarkMode, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<EventBloc>().add(LoadEvents());
        // Wait a bit for the refresh to complete
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _EventManagementCard(
              event: event,
              isDarkMode: isDarkMode,
            ),
          );
        },
      ),
    );
  }
}

class _EventManagementCard extends StatelessWidget {
  final Event event;
  final bool isDarkMode;

  const _EventManagementCard({
    required this.event,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'edit') {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddEditEventScreen(event: event),
                        ),
                      );
                      
                      // Refresh events if something was updated
                      if (result == true) {
                        context.read<EventBloc>().add(LoadEvents());
                      }
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(context);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('แก้ไข'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('ลบ', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: isDarkMode ? Colors.white70 : Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDate(event.date),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: isDarkMode ? Colors.white70 : Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    event.location ?? 'ไม่ระบุสถานที่',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.people,
                  size: 16,
                  color: isDarkMode ? Colors.white70 : Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '${event.registrationCount} คนลงทะเบียน',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                if (event.maxCapacity != null) ...[
                  Text(
                    ' / ${event.maxCapacity} คน',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
            // 🆕 Capacity Management Section
            if (event.maxCapacity != null || event.registrationCount > 0) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.group_outlined,
                              size: 16,
                              color: isDarkMode ? Colors.white70 : Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'จำนวนสูงสุด: ${event.maxCapacity ?? "ไม่จำกัด"}',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white70 : Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        if (event.maxCapacity != null) ...[
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: event.registrationCount / event.maxCapacity!,
                            backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              event.isFull ? Colors.red : 
                              event.isNearlyFull ? Colors.orange : Colors.green,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  label: Text(
                    event.category ?? 'อื่นๆ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: _getCategoryColor(event.category ?? 'อื่นๆ'),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(event.date),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(event.date),
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
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบ'),
          content: Text('คุณต้องการลบกิจกรรม "${event.title}" หรือไม่?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Delete the event
                context.read<EventBloc>().add(DeleteEvent(event.id.toString()));
                
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('กิจกรรมถูกลบเรียบร้อยแล้ว'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('ลบ'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
      'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year + 543}';
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'กีฬา':
        return Colors.blue;
      case 'ศิลปกรรม':
        return Colors.purple;
      case 'วิชาการ':
        return Colors.green;
      case 'อื่นๆ':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(DateTime eventDate) {
    final now = DateTime.now();
    if (eventDate.isBefore(now)) {
      return Colors.red;
    } else if (eventDate.difference(now).inDays <= 3) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  String _getStatusText(DateTime eventDate) {
    final now = DateTime.now();
    if (eventDate.isBefore(now)) {
      return 'สิ้นสุดแล้ว';
    } else if (eventDate.difference(now).inDays <= 3) {
      return 'ใกล้ถึงกำหนด';
    } else {
      return 'กำลังดำเนินการ';
    }
  }
}