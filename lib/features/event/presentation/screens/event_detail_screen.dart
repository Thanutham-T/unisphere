import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/event.dart';
import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.instance<EventBloc>(),
      child: _EventDetailContent(event: event),
    );
  }
}

class _EventDetailContent extends StatefulWidget {
  final Event event;

  const _EventDetailContent({
    required this.event,
  });

  @override
  State<_EventDetailContent> createState() => _EventDetailContentState();
}

class _EventDetailContentState extends State<_EventDetailContent> {
  late bool _isRegistered;
  late Event _currentEvent;

  @override
  void initState() {
    super.initState();
    _currentEvent = widget.event;
    _isRegistered = widget.event.isRegistered;
    
    // Load current event details
    context.read<EventBloc>().add(LoadEventById(_currentEvent.id.toString()));
  }

  void _toggleRegistration() {
    // Check if event is full and user is not already registered
    if (_currentEvent.isFull && !_isRegistered) {
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

    if (_isRegistered) {
      // Show confirmation dialog for unregistration
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ยกเลิกการลงทะเบียน'),
          content: Text('คุณต้องการยกเลิกการลงทะเบียน "${_currentEvent.title}" หรือไม่?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<EventBloc>().add(UnregisterFromEvent(_currentEvent.id.toString()));
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
      String confirmationText = 'คุณต้องการลงทะเบียน "${_currentEvent.title}" หรือไม่?';
      if (_currentEvent.hasCapacityLimit && _currentEvent.availableSpots != null) {
        if (_currentEvent.isNearlyFull) {
          confirmationText += '\n\n⚠️ เหลือที่นั่งอีก ${_currentEvent.availableSpots} ที่เท่านั้น!';
        } else {
          confirmationText += '\n\n✅ มีที่นั่งว่างอีก ${_currentEvent.availableSpots} ที่';
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
                context.read<EventBloc>().add(RegisterForEvent(_currentEvent.id.toString()));
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final dateFormat = DateFormat('d MMMM yyyy', 'th');
    
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey[50],
      body: BlocConsumer<EventBloc, EventState>(
        listener: (context, state) {
          if (state is EventActionSuccess) {
            // Reload current event after successful registration/unregistration
            context.read<EventBloc>().add(LoadEventById(_currentEvent.id.toString()));
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is EventDetailLoaded) {
            // Update current event data and registration status
            setState(() {
              _currentEvent = state.event;
              _isRegistered = state.event.isRegistered;
            });
          } else if (state is EventError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              CustomScrollView(
            slivers: [
              // App Bar with Image
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                iconTheme: const IconThemeData(color: Colors.white),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Event Image
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: _currentEvent.imageUrl != null && _currentEvent.imageUrl!.isNotEmpty
                                ? (_currentEvent.imageUrl!.startsWith('file://')
                                    ? FileImage(File(_currentEvent.imageUrl!.substring(7)))
                                    : NetworkImage(_currentEvent.imageUrl!) as ImageProvider)
                                : const AssetImage('assets/icons/unisphere_logo.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      // Event Category Badge
                      if (_currentEvent.category != null)
                        Positioned(
                          top: 60,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isDarkMode 
                                ? const Color(0xFF6366F1).withOpacity(0.9)
                                : const Color(0xFF2E3192).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _currentEvent.category!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              // Content
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF121212) : Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Availability
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                _currentEvent.title,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getAvailabilityColor(isDarkMode),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _isRegistered ? 'ลงทะเบียนแล้ว' : 'ยังไม่ลงทะเบียน',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Event Details Cards
                        _buildInfoCard(
                          icon: Icons.calendar_today,
                          title: 'วันที่',
                          subtitle: dateFormat.format(_currentEvent.date),
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 12),
                        
                        _buildInfoCard(
                          icon: Icons.location_on,
                          title: 'สถานที่',
                          subtitle: _currentEvent.location ?? 'ไม่ระบุ',
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 12),
                        
                        _buildInfoCard(
                          icon: Icons.people,
                          title: 'ผู้เข้าร่วม',
                          subtitle: '${_currentEvent.registrationCount} คน',
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 12),
                        
                        // 🆕 Capacity Section
                        _buildCapacitySection(isDarkMode),
                        const SizedBox(height: 24),
                        
                        // Description
                        Text(
                          'รายละเอียด',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _currentEvent.description ?? 'ไม่มีรายละเอียด',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: isDarkMode ? Colors.white70 : Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Loading overlay when performing actions
          if (state is EventActionLoading && 
              (state.eventId == _currentEvent.id.toString()))
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      );
    },
  ),
      
      // Bottom Registration Button
      bottomNavigationBar: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          final isLoading = state is EventActionLoading &&
              (state.eventId == _currentEvent.id.toString());
          
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: (!isLoading && !(_currentEvent.isFull && !_isRegistered))
                      ? _toggleRegistration
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (_currentEvent.isFull && !_isRegistered)
                        ? Colors.grey[600] // Disabled color for full events
                        : _isRegistered
                          ? (isDarkMode ? Colors.orange.shade600 : Colors.orange)
                          : (isDarkMode ? const Color(0xFF8B8FFF) : const Color(0xFF2E3192)),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_currentEvent.isFull && !_isRegistered)
                              const Icon(Icons.block, size: 20)
                            else if (_isRegistered)
                              const Icon(Icons.remove, size: 20)
                            else
                              const Icon(Icons.add, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              _getButtonText(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDarkMode 
                ? const Color(0xFF6366F1).withOpacity(0.2)
                : const Color(0xFF2E3192).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: isDarkMode 
                ? const Color(0xFF8B8FFF)
                : const Color(0xFF2E3192),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getAvailabilityColor(bool isDarkMode) {
    if (_isRegistered) {
      return isDarkMode ? Colors.green.shade600 : Colors.green;
    } else {
      return isDarkMode ? const Color(0xFF8B8FFF) : const Color(0xFF2E3192);
    }
  }

  // 🆕 Build capacity section widget
  Widget _buildCapacitySection(bool isDarkMode) {
    if (!_currentEvent.hasCapacityLimit) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.blue[900] : Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode ? Colors.blue[700]! : Colors.blue[200]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.people_outline,
              color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'จำนวนผู้เข้าร่วม',
                    style: TextStyle(
                      color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_currentEvent.registrationCount} คน (ไม่จำกัดจำนวน)',
                    style: TextStyle(
                      color: isDarkMode ? Colors.blue[400] : Colors.blue[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Color statusColor;
    Color backgroundColor;
    IconData statusIcon;
    
    if (_currentEvent.isFull) {
      statusColor = Colors.red;
      backgroundColor = isDarkMode ? Colors.red[900]! : Colors.red[50]!;
      statusIcon = Icons.block;
    } else if (_currentEvent.isNearlyFull) {
      statusColor = Colors.orange;
      backgroundColor = isDarkMode ? Colors.orange[900]! : Colors.orange[50]!;
      statusIcon = Icons.warning_rounded;
    } else {
      statusColor = Colors.green;
      backgroundColor = isDarkMode ? Colors.green[900]! : Colors.green[50]!;
      statusIcon = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                statusIcon,
                color: statusColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'สถานะการลงทะเบียน',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              if (_currentEvent.isFull)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'เต็ม',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: _currentEvent.capacityPercentage,
              backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              minHeight: 8,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Registration stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentEvent.registrationCount} / ${_currentEvent.maxCapacity} คน',
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              if (!_currentEvent.isFull && _currentEvent.availableSpots != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _currentEvent.isNearlyFull 
                      ? Colors.orange[100] 
                      : Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'เหลือ ${_currentEvent.availableSpots} ที่นั่ง',
                    style: TextStyle(
                      color: _currentEvent.isNearlyFull 
                        ? Colors.orange[800] 
                        : Colors.green[800],
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          
          if (_currentEvent.isFull) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.red[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'กิจกรรมนี้เต็มแล้ว ไม่สามารถลงทะเบียนเพิ่มได้',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getButtonText() {
    if (_currentEvent.isFull && !_isRegistered) {
      return 'กิจกรรมเต็มแล้ว';
    } else if (_isRegistered) {
      return 'ยกเลิกการลงทะเบียน';
    } else {
      return 'ลงทะเบียนเข้าร่วม';
    }
  }
}