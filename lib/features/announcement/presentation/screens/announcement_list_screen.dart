import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/announcement.dart';
import '../bloc/announcement_bloc.dart';
import '../widgets/announcement_card.dart';
import '../widgets/announcement_filter_widget.dart';
import 'announcement_admin_screen.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

class AnnouncementListScreen extends StatefulWidget {
  const AnnouncementListScreen({super.key});

  @override
  State<AnnouncementListScreen> createState() => _AnnouncementListScreenState();
}

class _AnnouncementListScreenState extends State<AnnouncementListScreen> {
  String? selectedCategory;
  String? selectedPriority;

  @override
  void initState() {
    super.initState();
    context.read<AnnouncementBloc>().add(const GetAnnouncementsEvent());
    // Load current user info to check role
    context.read<AuthBloc>().add(LoadCurrentUserRequested());
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'ประกาศ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : const Color(0xFF2E3192),
          ),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: isDarkMode ? Colors.white70 : const Color(0xFF2E3192),
            ),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          if (selectedCategory != null || selectedPriority != null)
            Container(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                children: [
                  if (selectedCategory != null)
                    Chip(
                      label: Text('หมวด: $selectedCategory'),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        setState(() {
                          selectedCategory = null;
                        });
                        _refreshAnnouncements();
                      },
                    ),
                  if (selectedPriority != null)
                    Chip(
                      label: Text('ความสำคัญ: $selectedPriority'),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        setState(() {
                          selectedPriority = null;
                        });
                        _refreshAnnouncements();
                      },
                    ),
                ],
              ),
            ),
          
          // Announcements list
          Expanded(
            child: BlocBuilder<AnnouncementBloc, AnnouncementState>(
              builder: (context, state) {
                if (state is AnnouncementLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                if (state is AnnouncementError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'เกิดข้อผิดพลาด',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _refreshAnnouncements(),
                          child: const Text('ลองใหม่'),
                        ),
                      ],
                    ),
                  );
                }
                
                if (state is AnnouncementLoaded) {
                  final announcements = state.announcements;
                  
                  if (announcements.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.announcement_outlined,
                            size: 64,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'ไม่มีประกาศ',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'ยังไม่มีประกาศในหมวดหมู่นี้',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return RefreshIndicator(
                    onRefresh: () async => _refreshAnnouncements(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: announcements.length,
                      itemBuilder: (context, index) {
                        final announcement = announcements[index];
                        return AnnouncementCard(
                          announcement: announcement,
                          onTap: () => _showAnnouncementDetail(announcement),
                        );
                      },
                    ),
                  );
                }
                
                return const SizedBox.shrink();
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
            return FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: context.read<AnnouncementBloc>(),
                      child: const AnnouncementAdminScreen(),
                    ),
                  ),
                );
              },
              tooltip: 'จัดการประกาศ (Admin)',
              child: const Icon(Icons.admin_panel_settings),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _refreshAnnouncements() {
    context.read<AnnouncementBloc>().add(
      GetAnnouncementsEvent(
        category: selectedCategory,
        priority: selectedPriority,
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AnnouncementFilterWidget(
        selectedCategory: selectedCategory,
        selectedPriority: selectedPriority,
        onCategoryChanged: (category) {
          setState(() {
            selectedCategory = category;
          });
          _refreshAnnouncements();
        },
        onPriorityChanged: (priority) {
          setState(() {
            selectedPriority = priority;
          });
          _refreshAnnouncements();
        },
      ),
    );
  }

  void _showAnnouncementDetail(Announcement announcement) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnnouncementDetailScreen(
          announcement: announcement,
        ),
      ),
    );
  }
}

class AnnouncementDetailScreen extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementDetailScreen({
    super.key,
    required this.announcement,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายละเอียดประกาศ'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Priority indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getPriorityColor(announcement.priority),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                announcement.priorityDisplayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Title
            Text(
              announcement.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Category
            Text(
              'หมวดหมู่: ${announcement.categoryDisplayName}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            
            // Content
            Text(
              announcement.content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            
            // Meta information
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ข้อมูลเพิ่มเติม',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (announcement.creatorName != null)
                    _buildInfoRow('ผู้สร้าง', announcement.creatorName!),
                  _buildInfoRow('วันที่สร้าง', _formatDate(announcement.createdAt)),
                  _buildInfoRow('วันที่อัปเดต', _formatDate(announcement.updatedAt)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}