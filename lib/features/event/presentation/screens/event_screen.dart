import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../widgets/event_card.dart';
import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';
import 'event_detail_screen.dart';
import 'event_management_screen.dart';
import '../../domain/entities/event.dart';
import '../../../../core/utils/global_error_handler.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.instance<EventBloc>(),
      child: const _EventScreenContent(),
    );
  }
}

class _EventScreenContent extends StatefulWidget {
  const _EventScreenContent();

  @override
  State<_EventScreenContent> createState() => _EventScreenContentState();
}

class _EventScreenContentState extends State<_EventScreenContent> {
  String _selectedCategory = 'ทั้งหมด';
  bool _showRegisteredOnly = false; // เพิ่มตัวกรองลงทะเบียนแล้ว
  
  final List<String> _categories = [
    'ทั้งหมด',
    'วิชาการ',
    'จิตอาสา',
    'กีฬา',
    'ศิลปวัฒนธรรม',
    'พัฒนาผู้นำ',
    'สันทนา',
  ];

  @override
  void initState() {
    super.initState();
    // Check if events are already loaded, if not load them
    final currentState = context.read<EventBloc>().state;
    if (currentState is EventLoading || 
        (currentState is! EventLoaded && currentState is! EventDetailLoaded)) {
      context.read<EventBloc>().add(LoadEvents());
    }
  }

  // Helper method to get display name for category
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'กิจกรรม',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : const Color(0xFF2E3192),
          ),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          // Filter for registered events only
          IconButton(
            icon: Icon(
              _showRegisteredOnly ? Icons.bookmark : Icons.bookmark_border,
              color: _showRegisteredOnly 
                ? (isDarkMode ? const Color(0xFF8B8FFF) : const Color(0xFF2E3192))
                : (isDarkMode ? Colors.white70 : const Color(0xFF2E3192)),
            ),
            onPressed: () {
              setState(() {
                _showRegisteredOnly = !_showRegisteredOnly;
              });
            },
            tooltip: _showRegisteredOnly ? 'แสดงกิจกรรมทั้งหมด' : 'แสดงเฉพาะที่ลงทะเบียน',
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter Chips
          _buildCategoryFilter(isDarkMode),
          
          // Events List
          Expanded(
            child: BlocConsumer<EventBloc, EventState>(
        listener: (context, state) {
          if (state is EventError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is EventUnauthorized) {
            // Handle token expiration with auto logout
            GlobalErrorHandler.handleUnauthorizedException(
              context,
              UnauthorizedException(state.message),
            );
          } else if (state is EventActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // No need to manually refresh - EventBloc auto-refreshes now
          }
        },
        builder: (context, state) {
          if (state is EventLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is EventActionLoading) {
            // Show loading overlay for CRUD operations but keep existing UI
            return Stack(
              children: [
                // Show the current events list (if available from previous state)
                BlocBuilder<EventBloc, EventState>(
                  buildWhen: (previous, current) => current is EventLoaded,
                  builder: (context, previousState) {
                    if (previousState is EventLoaded) {
                      final filteredEvents = _filterEvents(previousState.events);
                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<EventBloc>().add(RefreshEvents());
                        },
                        child: _buildEventGrid(filteredEvents, isDarkMode),
                      );
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
                } else if (state is EventLoaded) {
                  final filteredEvents = _filterEvents(state.events);
                  
                  if (filteredEvents.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 64,
                            color: isDarkMode ? Colors.white54 : Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'ไม่มีกิจกรรมในหมวดหมู่นี้',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white70 : Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<EventBloc>().add(RefreshEvents());
                    },
                    child: _buildEventGrid(filteredEvents, isDarkMode),
                  );
                } else if (state is EventDetailLoaded) {
                  // When returning from detail page, reload the events list
                  context.read<EventBloc>().add(LoadEvents());
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is EventError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: isDarkMode ? Colors.white54 : Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'เกิดข้อผิดพลาด',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.grey[600],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white54 : Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 24),
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
                
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          // Show FAB only for admin users
          if (authState is AuthAuthenticated && 
              authState.user.role?.toLowerCase() == 'admin') {
            return FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EventManagementScreen(),
                  ),
                );
                
                // Refresh events when returning from management screen
                context.read<EventBloc>().add(LoadEvents());
              },
              backgroundColor: const Color(0xFF2E3192),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text('จัดการกิจกรรม'),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  List<Event> _filterEvents(List<Event> events) {
    List<Event> filteredEvents = events;
    
    // Filter by category
    if (_selectedCategory != 'ทั้งหมด') {
      filteredEvents = filteredEvents.where((event) => event.category == _selectedCategory).toList();
    }
    
    // Filter by registration status only
    if (_showRegisteredOnly) {
      filteredEvents = filteredEvents.where((event) => event.isRegistered).toList();
    }
    
    return filteredEvents;
  }

  Widget _buildCategoryFilter(bool isDarkMode) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              selectedColor: isDarkMode 
                ? const Color(0xFF6366F1).withOpacity(0.3)
                : const Color(0xFF2E3192).withOpacity(0.1),
              backgroundColor: isDarkMode 
                ? const Color(0xFF2D2D2D)
                : Colors.grey[100],
              labelStyle: TextStyle(
                color: isSelected 
                  ? (isDarkMode ? const Color(0xFF8B8FFF) : const Color(0xFF2E3192))
                  : (isDarkMode ? Colors.white70 : Colors.grey[700]),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected 
                  ? (isDarkMode ? const Color(0xFF6366F1) : const Color(0xFF2E3192))
                  : (isDarkMode ? Colors.grey[600]! : Colors.grey[300]!),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventGrid(List<Event> events, bool isDarkMode) {
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
          child: EventCard(
            event: event,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EventDetailScreen(event: event),
                ),
              );
            },
          ),
        );
      },
      ),
    );
  }

}